import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';

abstract class MarkerRepository {
  /// 회원가입/로그인.
  Future<MarkerListEntity> markerList(
    double latitude,
    double longitude,
  );

  Future<MarkerObtainEntity> obtainMarker({
    required String id,
    required int ts,
    required double latitude,
    required double longitude,
  });
}
