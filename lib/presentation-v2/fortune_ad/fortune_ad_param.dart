import 'package:freezed_annotation/freezed_annotation.dart';

import 'admanager/fortune_ad.dart';

part 'fortune_ad_param.freezed.dart';

@freezed
class FortuneAdParam with _$FortuneAdParam {
  factory FortuneAdParam({
    required int ts,
    required Future<FortuneAdState?> adState,
  }) = _FortuneAdParam;
}
