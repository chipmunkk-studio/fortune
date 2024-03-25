import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_obtain_success_return.freezed.dart';

@freezed
class FortuneObtainSuccessReturn with _$FortuneObtainSuccessReturn{
  factory FortuneObtainSuccessReturn({
    required MarkerObtainEntity markerObtainEntity,
  }) = _FortuneObtainSuccessReturn;
}
