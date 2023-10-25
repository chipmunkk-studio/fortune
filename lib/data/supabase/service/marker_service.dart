import 'dart:math';

import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_marker_random_insert.dart';
import 'package:fortune/data/supabase/request/request_marker_update.dart';
import 'package:fortune/data/supabase/response/marker_response.dart';
import 'package:fortune/data/supabase/service/ingredient_service.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/marker_entity.dart';
import 'package:fortune/env.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarkerService {
  static const fullSelectQuery = '*,'
      '${TableName.ingredients}(${IngredientService.fullSelectQuery})';
  final SupabaseClient _client = Supabase.instance.client;
  final Environment env;

  MarkerService({
    required this.env,
  });

  // 내 근처에 있는 마커들 모두 가져오기.
  Future<List<MarkerEntity>> findAllMarkersNearByMyLocation(
    double? latitude,
    double? longitude,
  ) async {
    try {
      // 위도와 경도 1도당 대략적인 거리 (km)
      const double oneDegOfLatInKm = 111.0;
      const double oneDegOfLngInKm = 111.0; // 적도에서의 값으로, 실제로는 위도에 따라 다름.
      // 정사각형의 한 변의 길이 (m -> km)
      double rectangleSideLengthInKm = sqrt(2) * env.remoteConfig.randomDistance; // 707m
      // 정사각형 영역의 위아래 좌우 경계값 계산
      double latDiff = rectangleSideLengthInKm / oneDegOfLatInKm;
      double lngDiff = rectangleSideLengthInKm / oneDegOfLngInKm;
      // 정사각형 영역의 경계값 계산
      double minLat = latitude! - (latDiff / 2);
      double maxLat = latitude + (latDiff / 2);
      double minLng = longitude! - (lngDiff / 2);
      double maxLng = longitude + (lngDiff / 2);

      final response = await _client
          .from(TableName.markers)
          .select(fullSelectQuery)
          .gte('latitude', minLat)
          .lte('latitude', maxLat)
          .gte('longitude', minLng)
          .lte('longitude', maxLng)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final ingredients = response.map((e) => MarkerResponse.fromJson(e)).toList();
        return ingredients;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 마커 재배치.
  Future<void> reLocateMarker(
    MarkerEntity marker,
    int userId,
  ) async {
    try {
      final ingredient = marker.ingredient;
      final randomLocation = getRandomLocation(
        marker.latitude,
        marker.longitude,
        ingredient.distance,
      );
      await update(
        marker.id,
        location: randomLocation,
        lastObtainUser: userId,
        hitCount: marker.hitCount + 1,
      );
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 아이디로 마커를 찾음.
  Future<MarkerEntity> findMarkerById(int id) async {
    try {
      final List<dynamic> response = await _client
          .from(TableName.markers)
          .select(
            fullSelectQuery,
          )
          .eq("id", id)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(
          errorMessage: "마커가 존재하지 않습니다.",
        );
      } else {
        final marker = response.map((e) => MarkerResponse.fromJson(e)).toList();
        return marker.single;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 마커 위치로 찾음.
  Future<MarkerEntity?> findMarkerByLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final List<dynamic> response = await _client
          .from(
            TableName.markers,
          )
          .select(fullSelectQuery)
          .match({
        'latitude': latitude,
        'longitude': longitude,
      }).toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final marker = response.map((e) => MarkerResponse.fromJson(e)).toList();
        return marker.single;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 마커 업데이트.
  Future<MarkerResponse> update(
    int id, {
    LatLng? location,
    int? lastObtainUser,
    int? hitCount,
  }) async {
    try {
      MarkerEntity marker = await findMarkerById(id);

      final requestToUpdate = RequestMarkerUpdate(
        latitude: location?.latitude ?? marker.latitude,
        longitude: location?.longitude ?? marker.longitude,
        lastObtainUser: lastObtainUser ?? marker.lastObtainUser,
        hitCount: hitCount ?? marker.hitCount,
      );

      final updateMarker = await _client
          .from(TableName.markers)
          .update(
            requestToUpdate.toJson(),
          )
          .eq("id", id)
          .select(fullSelectQuery);
      return updateMarker.map((e) => MarkerResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 마커 삭제.
  Future<void> delete(int id) async {
    try {
      MarkerEntity marker = await findMarkerById(id);
      await _client.from(TableName.markers).delete().eq("id", marker.id);
    } on Exception catch (e) {
      throw e.handleException(); // using extension method here
    }
  }

  // 마커 삽입.
  Future<bool> insertRandomMarkers({
    required List<RequestMarkerRandomInsert> markers,
  }) async {
    try {
      for (var element in markers) {
        await _client.from(TableName.markers).insert(element.toJson());
      }
      return true;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
