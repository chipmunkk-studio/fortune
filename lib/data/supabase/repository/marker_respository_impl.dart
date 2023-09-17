import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_marker_random_insert.dart';
import 'package:fortune/data/supabase/service/marker_service.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/entity/marker_entity.dart';
import 'package:fortune/domain/supabase/repository/marker_respository.dart';

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

      // 티켓들.
      final ticketIngredients = ingredients.where((element) => element.type == IngredientType.ticket).toList();

      // 티켓/마커 섞음.
      nonTicketAndUniqueIngredients.shuffle(Random());
      ticketIngredients.shuffle(Random());

      List<RequestMarkerRandomInsert> markers = [];

      // 재료 N개 / 티켓 N개 랜덤 픽.
      final collectedMarkerList = nonTicketAndUniqueIngredients.take(markerCount).toList();
      final collectedTicketList = ticketIngredients.take(ticketCount).toList();

      // 현재 위치를 기준으로 마커 N개 생성.
      for (var element in collectedMarkerList) {
        final requestMarker = generateRandomMarker(lat: latitude, lon: longitude, ingredient: element);
        markers.add(requestMarker);
      }

      // 현재 위치를 기준으로 티켓을 N개 생성.
      for (var element in collectedTicketList) {
        final requestMarker = generateRandomMarker(lat: latitude, lon: longitude, ingredient: element);
        markers.add(requestMarker);
      }

      return await _markerService.insertRandomMarkers(markers: markers);
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '마커 생성 실패',
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
