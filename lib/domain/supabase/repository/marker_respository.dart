import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/entity/marker_entity.dart';
import 'package:latlong2/latlong.dart';

abstract class MarkerRepository {
  // 마커 목록 불러오기.
  Future<List<MarkerEntity>> getAllMarkers(
    double? latitude,
    double? longitude,
  );

  // 마커 재배치.
  Future<void> reLocateMarker({
    required MarkerEntity marker,
    required int userId,
    required LatLng location,
  });

  // 마커 생성.
  Future<bool> getRandomMarkers({
    required double latitude,
    required double longitude,
    required List<IngredientEntity> ingredients,
    required int coinCounts,
    required int markerCount,
  });

  // 아이디로 찾기.
  Future<MarkerEntity> findMarkerById(int markerId);

  // 마커 위치로 찾기.
  Future<MarkerEntity?> findMarkerByLocation({
    required double latitude,
    required double longitude,
  });
}
