import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_ad_param.freezed.dart';

@freezed
class FortuneAdParam with _$FortuneAdParam {
  factory FortuneAdParam({
    required int ts,
  }) = _FortuneAdParam;
}
