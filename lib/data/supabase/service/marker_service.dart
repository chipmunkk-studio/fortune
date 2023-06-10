import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_update.dart';
import 'package:foresh_flutter/data/supabase/response/marker_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:synchronized/synchronized.dart';

class MarkerService {
  static const _markerTableName = "markers";
  static const _tag = '[MarkerService] ';

  final SupabaseClient _client;

  MarkerService(this._client);

  // 내 근처에 있는 마커들 모두 가져오기.
  Future<List<MarkerEntity>> findAllMarkersNearByMyLocation(
    double? latitude,
    double? longitude,
  ) async {
    try {
      double lat = latitude ?? 0;
      double lng = longitude ?? 0;
      // 위도와 경도 1도당 대략적인 거리 (km)
      const double oneDegOfLatInKm = 111.0;
      const double oneDegOfLngInKm = 79.0;
      // 직사각형의 한 변의 길이 (m -> km)
      const double rectangleSideLengthInMeters = 5000.0;
      // 직사각형 영역의 위아래 좌우 경계값 계산
      double latDiff = rectangleSideLengthInMeters / (oneDegOfLatInKm * 1000);
      double lngDiff = rectangleSideLengthInMeters / (oneDegOfLngInKm * 1000);
      // 직사각형 영역의 경계값 계산
      double minLat = lat - (latDiff / 2);
      double maxLat = lat + (latDiff / 2);
      double minLng = lng - (lngDiff / 2);
      double maxLng = lng + (lngDiff / 2);
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
      // 소멸성이고, 이미 획득한 사람이 있다면,
      if (marker.lastObtainUser != null && ingredient.isExtinct) {
        await delete(marker.id);
      }
      // 소멸성 마커이고, 획득한 사람이 없을떄.
      else if (ingredient.isExtinct) {
        await update(marker.id, lastObtainUser: user.id);
      }
      // 랜덤으로 위치 하는 마커 일 경우.
      else {
        final randomLocation = getRandomLocation(
          marker.latitude,
          marker.longitude,
          ingredient.distance,
        );
        await update(marker.id, location: randomLocation, lastObtainUser: user.id);
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 마커를 찾음.
  Future<MarkerEntity?> findMarkerById(int id) async {
    try {
      final List<dynamic> response = await _client
          .from(_markerTableName)
          .select(
            "*,ingredient(*)",
          )
          .eq("id", id)
          .toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final marker = response.map((e) => MarkerResponse.fromJson(e)).toList();
        return marker.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 업데이트.
  Future<MarkerResponse> update(
    int id, {
    LatLng? location,
    int? lastObtainUser,
  }) async {
    try {
      MarkerEntity? marker = await findMarkerById(id);
      if (marker != null) {
        final updateMarker = await _client
            .from(_markerTableName)
            .update(
              RequestMarkerUpdate(
                latitude_: location?.latitude ?? marker.latitude,
                longitude_: location?.longitude ?? marker.longitude,
                lastObtainUser_: lastObtainUser ?? marker.lastObtainUser,
              ).toJson(),
            )
            .eq("id", id)
            .select("*,ingredient(*)");
        return updateMarker.map((e) => MarkerResponse.fromJson(e)).toList().single;
      } else {
        throw const PostgrestException(message: '마커를 업데이트 하지못했습니다.');
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 삭제.
  Future<void> delete(int id) async {
    try {
      MarkerEntity? marker = await findMarkerById(id);
      if (marker != null) {
        await _client.from(_markerTableName).delete().eq("id", id);
      } else {
        throw const PostgrestException(message: '마커를 삭제하지 못했습니다.');
      }
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
