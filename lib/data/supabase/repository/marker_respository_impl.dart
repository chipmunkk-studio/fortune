import 'dart:math';

import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/data/supabase/request/request_marker_random_insert.dart';
import 'package:fortune/data/supabase/service/marker_service.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/entity/marker_entity.dart';
import 'package:fortune/domain/supabase/repository/marker_respository.dart';
import 'package:latlong2/latlong.dart';

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
        description: FortuneTr.msgUpdateMarkerInfo,
      );
    }
  }

  // 마커 랜덤 배치.
  @override
  Future<void> reLocateMarker({
    required MarkerEntity marker,
    required FortuneUserEntity user,
    required LatLng location,
  }) async {
    try {
      if (marker.ingredient.type != IngredientType.coin) {
        final locationMarker = await findMarkerByLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        if (locationMarker == null) {
          throw CommonFailure(errorMessage: '이미 누군가 마커를 획득 했어요!');
        }
      }
      await _markerService.reLocateMarker(marker, user);
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: e.message,
      );
    }
  }

  @override
  Future<bool> getRandomMarkers({
    required double latitude,
    required double longitude,
    required List<IngredientEntity> ingredients,
    required int coinCounts,
    required int markerCount,
  }) async {
    try {
      // 노말인 마커들만 뿌림.
      final nonTicketAndUniqueIngredients = ingredients
          .where(
            (ingredient) => ingredient.type == IngredientType.normal,
          )
          .toList();

      // 티켓들.
      final ticketIngredients = ingredients.where((element) => element.type == IngredientType.coin).toList();

      // 티켓/마커 섞음.
      nonTicketAndUniqueIngredients.shuffle(Random());
      ticketIngredients.shuffle(Random());

      List<RequestMarkerRandomInsert> markers = [];

      // 재료 N개 / 티켓 N개 랜덤 픽.
      final collectedMarkerList = nonTicketAndUniqueIngredients.take(markerCount).toList();
      final collectedTicketList = ticketIngredients.take(coinCounts).toList();

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

  @override
  Future<MarkerEntity?> findMarkerByLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final marker = await _markerService.findMarkerByLocation(
        latitude: latitude,
        longitude: longitude,
      );
      return marker;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '마커를 찾을 수 없습니다',
      );
    }
  }
}
