import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/data/supabase/service/marker_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:synchronized/synchronized.dart';

class MarkerRepositoryImpl extends MarkerRepository {
  final MarkerService _markerService;
  final UserService _userService;
  final Lock _lock = Lock();

  MarkerRepositoryImpl(
    this._markerService,
    this._userService,
  );

  // 마커 목록 불러오기.
  @override
  Future<FortuneResult<List<MarkerEntity>>> getAllMarkers(
    double? latitude,
    double? longitude,
  ) async {
    try {
      final List<MarkerEntity> markers = await _markerService.findAllMarkersNearByMyLocation(latitude, longitude);
      return Right(markers);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }

  // 마커 획득 하기.
  @override
  Future<FortuneResult<FortuneUserEntity>> obtainMarker(int id) {
    return _lock.synchronized<FortuneResult<FortuneUserEntity>>(() async {
      try {
        final authClient = Supabase.instance.client.auth;
        final marker = await _markerService.findMarkerById(id);
        // 마커가 존재하지 않을 경우.
        if (marker == null) {
          throw CommonFailure(
            errorMessage: "이미 누군가 마커를 획득했습니다",
          );
        }
        final ingredient = marker.ingredient;
        final FortuneUserEntity? user = await _userService.findUserByPhone(authClient.currentUser?.phone);
        if (user!.ticket <= 0 && ingredient.type != IngredientType.ticket) {
          // 티켓이 없고, 마커가 티켓이 아닐 경우.
          throw CommonFailure(
            errorMessage: "보유한 티켓이 없습니다",
          );
        }

        // 마커 획득 처리.
        await _markerService.obtainMarker(marker, user);

        int updatedTicket = user.ticket;
        int updatedTrashObtainCount = user.trashObtainCount;
        int markerObtainCount = user.markerObtainCount;
        bool isTrashMarker = marker.lastObtainUser != null && ingredient.type == IngredientType.ticket;

        if (!isTrashMarker) {
          updatedTicket = user.ticket + ingredient.rewardTicket;
          markerObtainCount = markerObtainCount + 1;
        } else {
          updatedTrashObtainCount = user.trashObtainCount + 1;
        }

        // 사용자 티켓 정보 업데이트.
        final updateUser = await _userService.update(
          user.phone,
          ticket: updatedTicket,
          trashObtainCount: updatedTrashObtainCount,
          markerObtainCount: markerObtainCount,
        );

        return Right(updateUser);
      } on FortuneFailure catch (e) {
        FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
        return Left(e);
      }
    });
  }

  @override
  Future<FortuneResult<bool>> getRandomMarkers({
    required double latitude,
    required double longitude,
    required List<IngredientEntity> ingredients,
    required int ticketCount,
    required int markerCount,
  }) async {
    try {
      // 티켓이 아닌 리스트들만 뽑음.
      final nonTicketIngredients = ingredients
          .where(
            (ingredient) => ingredient.type != IngredientType.ticket,
          )
          .toList();

      // 티켓.
      final ticketIngredient = ingredients.firstWhereOrNull((element) => element.type == IngredientType.ticket);

      // 티켓 아닌거 섞음.
      nonTicketIngredients.shuffle(Random());

      List<RequestMarkerRandomInsert> markers = [];

      // 재료 N개 랜덤 픽.
      final collectedList = nonTicketIngredients.take(markerCount).toList();

      for (var element in collectedList) {
        final requestMarker = generateRandomMarker(lat: latitude, lon: longitude, ingredient: element);
        markers.add(requestMarker);
      }

      if (ticketIngredient != null) {
        for (int i = 0; i < ticketCount; i++) {
          final requestMarker = generateRandomMarker(lat: latitude, lon: longitude, ingredient: ticketIngredient);
          markers.add(requestMarker);
        }
      }

      await _markerService.insertRandomMarkers(markers: markers);
      return Right(markers.isNotEmpty);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }

  @override
  Future<FortuneResult<void>> hitMarker(int id) async {
    try {
      final marker = await _markerService.findMarkerById(id);
      if (marker == null) {
        throw CommonFailure(
          errorMessage: "마커가 존재하지 않습니다",
        );
      }
      await _markerService.update(id, hitCount: marker.hitCount + 1);
      return const Right(null);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }
}
