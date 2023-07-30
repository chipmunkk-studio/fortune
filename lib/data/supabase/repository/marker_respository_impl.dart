import 'dart:math';

import 'package:collection/collection.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/data/supabase/service/marker_service.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';

class MarkerRepositoryImpl extends MarkerRepository {
  final MarkerService _markerService;

  MarkerRepositoryImpl(
    this._markerService,
  );

  // 마커 목록 불러오기.
  @override
  Future<List<MarkerEntity>> getAllMarkers(
    double? latitude,
    double? longitude,
  ) async {
    try {
      final List<MarkerEntity> markers = await _markerService.findAllMarkersNearByMyLocation(latitude, longitude);
      return markers;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '마커 목록 불러오기 실패',
      );
    }
  }

  // 마커 랜덤 배치.
  @override
  Future<void> reLocateMarker({
    required MarkerEntity marker,
    required FortuneUserEntity user,
  }) async {
    try {
      await _markerService.reLocateMarker(marker, user);
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '마커 배치 실패',
      );
    }
  }

  @override
  Future<bool> getRandomMarkers({
    required double latitude,
    required double longitude,
    required List<IngredientEntity> ingredients,
    required int ticketCount,
    required int markerCount,
  }) async {
    try {
      // 티켓/유니크 가 아닌 리스트 들만 뽑음.
      final nonTicketAndUniqueIngredients = ingredients
          .where(
            (ingredient) => ingredient.type != IngredientType.ticket && ingredient.type != IngredientType.unique,
          )
          .toList();

      // 티켓.
      final ticketIngredient = ingredients.firstWhereOrNull((element) => element.type == IngredientType.ticket);

      // 티켓 아닌거 섞음.
      nonTicketAndUniqueIngredients.shuffle(Random());

      List<RequestMarkerRandomInsert> markers = [];

      // 재료 N개 랜덤 픽.
      final collectedList = nonTicketAndUniqueIngredients.take(markerCount).toList();

      // 현재 위치를 기준으로 마커 N개 생성.
      for (var element in collectedList) {
        final requestMarker = generateRandomMarker(lat: latitude, lon: longitude, ingredient: element);
        markers.add(requestMarker);
      }

      // 현재 위치를 기준으로 티켓을 N개 생성.
      if (ticketIngredient != null) {
        for (int i = 0; i < ticketCount; i++) {
          final requestMarker = generateRandomMarker(lat: latitude, lon: longitude, ingredient: ticketIngredient);
          markers.add(requestMarker);
        }
      }
      return await _markerService.insertRandomMarkers(markers: markers);
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '마커 생성 실패',
      );
    }
  }

  @override
  Future<void> hitMarker(int id) async {
    try {
      await _markerService.update(
        id,
        hitCount: 1,
      );
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '마커 획득 실패',
      );
    }
  }

  @override
  Future<MarkerEntity> findMarkerById(int markerId) async {
    try {
      final marker = await _markerService.findMarkerById(markerId);
      return marker;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '마커를 찾을 수 없습니다',
      );
    }
  }
}
