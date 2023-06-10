import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';

abstract class MarkerRepository {
  // 마커 목록 불러오기.
  Future<FortuneResult<List<MarkerEntity>>> getAllMarkers(
    double? latitude,
    double? longitude,
  );

  // 마커 획득.
  Future<FortuneResult<FortuneUserEntity>> obtainMarker(int id);

  // 마커 생성.
  Future<FortuneResult<bool>> getRandomMarkers({
    required double latitude,
    required double longitude,
    required List<IngredientEntity> ingredients,
    required int ticketCount,
    required int markerCount,
  });
}
