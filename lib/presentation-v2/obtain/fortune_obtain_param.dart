import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'fortune_obtain_param.freezed.dart';

@freezed
class FortuneObtainParam with _$FortuneObtainParam {
  factory FortuneObtainParam({
    required MarkerEntity marker,
    required int ts,
    required LatLng location,
  }) = _FortuneObtainParam;
}
