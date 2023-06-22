import 'dart:math';

import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_update.dart';
import 'package:foresh_flutter/data/supabase/response/marker_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:foresh_flutter/env.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarkerService {
  static const _markerTableName = "markers";

  final SupabaseClient _client;
  final Environment env;

  MarkerService(
    this._client, {
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
          .from(_markerTableName)
          .select("*,ingredient(*)")
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
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 획득.
  Future<void> obtainMarker(
    MarkerEntity marker,
    FortuneUserEntity user,
  ) async {
    try {
      final ingredient = marker.ingredient;
      // 소멸성이고, 이미 획득한 사람이 있다면 > 쓰레기 마커로 취급.
      final isTrashMarker = marker.lastObtainUser != null && ingredient.isExtinct;
      // 소멸성 마커이고, 획득한 사람이 없을떄.
      final isObtainableMarker = marker.lastObtainUser == null && ingredient.isExtinct;
      if (isTrashMarker) {
        await delete(marker.id);
      } else if (isObtainableMarker) {
        await update(marker.id, lastObtainUser: user.id);
      }
      // 랜덤으로 위치 하는 마커 일 경우.
      // hit_count를 1씩 올림.
      else {
        FortuneLogger.debug("랜덤으로 위치하는 마커 ");
        final randomLocation = getRandomLocation(
          marker.latitude,
          marker.longitude,
          ingredient.distance,
        );
        await update(
          marker.id,
          location: randomLocation,
          lastObtainUser: user.id,
          hitCount: marker.hitCount + 1,
        );
      }
    } on Exception catch (e) {
      FortuneLogger.error(e.toString());
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 마커를 찾음.
  Future<MarkerEntity> findMarkerById(int id) async {
    try {
      final List<dynamic> response = await _client
          .from(_markerTableName)
          .select(
            "*, ingredient(*)",
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
    } on Exception catch (e) {
      FortuneLogger.error(e.toString());
      throw (e.handleException()); // using extension method here
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
      final updateMarker = await _client
          .from(_markerTableName)
          .update(
            RequestMarkerUpdate(
              latitude: location?.latitude ?? marker.latitude,
              longitude: location?.longitude ?? marker.longitude,
              lastObtainUser: lastObtainUser ?? marker.lastObtainUser,
              hitCount: hitCount ?? marker.hitCount,
            ).toJson(),
          )
          .eq("id", id)
          .select("*,ingredient(*)");
      return updateMarker.map((e) => MarkerResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 삭제.
  Future<void> delete(int id) async {
    try {
      MarkerEntity marker = await findMarkerById(id);
      await _client.from(_markerTableName).delete().eq("id", marker.id);
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 삽입.
  Future<void> insertRandomMarkers({
    required List<RequestMarkerRandomInsert> markers,
  }) async {
    try {
      for (var element in markers) {
        await _client.from(_markerTableName).insert(element.toJson());
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
