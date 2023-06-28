import 'dart:math';

import 'package:collection/collection.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/data/supabase/service/marker_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
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
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
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
      final nonTicketAndTrashIngredients = ingredients
          .where(
            (ingredient) => ingredient.type != IngredientType.ticket && ingredient.type != IngredientType.unique,
          )
          .toList();

      // 티켓.
      final ticketIngredient = ingredients.firstWhereOrNull((element) => element.type == IngredientType.ticket);

      // 티켓 아닌거 섞음.
      nonTicketAndTrashIngredients.shuffle(Random());

      List<RequestMarkerRandomInsert> markers = [];

      // 재료 N개 랜덤 픽.
      final collectedList = nonTicketAndTrashIngredients.take(markerCount).toList();

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
      return markers.isNotEmpty;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> hitMarker(int id) async {
    try {
      final marker = await _markerService.findMarkerById(id);
      await _markerService.update(id, hitCount: marker.hitCount + 1);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<MarkerEntity> findMarkerById(int markerId) async {
    try {
      final marker = await _markerService.findMarkerById(markerId);
      return marker;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
