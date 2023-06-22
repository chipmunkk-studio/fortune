import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';

abstract class MarkerRepository {
  // 마커 목록 불러오기.
  Future<List<MarkerEntity>> getAllMarkers(
    double? latitude,
    double? longitude,
  );

  // 마커 획득.
  Future<FortuneUserEntity> obtainMarker(int id);

  // 마커 생성.
  Future<bool> getRandomMarkers({
    required double latitude,
    required double longitude,
    required List<IngredientEntity> ingredients,
    required int ticketCount,
    required int markerCount,
  });

  // 마커 기록하기.
  Future<void> hitMarker(int id);

  // 아이디로 찾기.
  Future<MarkerEntity> findMarkerById(int markerId);
}
