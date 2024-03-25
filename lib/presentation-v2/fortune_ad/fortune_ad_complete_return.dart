import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_ad_complete_return.freezed.dart';

@freezed
class FortuneAdCompleteReturn with _$FortuneAdCompleteReturn {
  factory FortuneAdCompleteReturn({
    required FortuneUserEntity user,
  }) = _FortuneAdCompleteReturn;
}
