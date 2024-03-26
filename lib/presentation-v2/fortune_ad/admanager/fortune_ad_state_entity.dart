import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'fortune_ad_state_entity.freezed.dart';

enum AdSourceType {
  AdMob,
  Custom,
  External,
  None,
}

abstract class FortuneAdState {}

@freezed
class FortuneAdmobAdStateEntity extends FortuneAdState with _$FortuneAdmobAdStateEntity {
  factory FortuneAdmobAdStateEntity({
    required RewardedAd? rewardedAd,
  }) = _FortuneAdmobAdStateEntity;

  factory FortuneAdmobAdStateEntity.initial([
    RewardedAd? rewardedAd,
  ]) =>
      FortuneAdmobAdStateEntity(
        rewardedAd: rewardedAd,
      );
}

@freezed
class FortuneCustomAdStateEntity extends FortuneAdState with _$FortuneCustomAdStateEntity {
  factory FortuneCustomAdStateEntity({
    required String source,
  }) = _FortuneCustomAdStateEntity;

  factory FortuneCustomAdStateEntity.initial([
    String? source,
  ]) =>
      FortuneCustomAdStateEntity(
        source: source ?? '',
      );
}

@freezed
class FortuneExternalAdStateEntity extends FortuneAdState with _$FortuneExternalAdStateEntity {
  factory FortuneExternalAdStateEntity({
    required String source,
  }) = _FortuneExternalAdStateEntity;

  factory FortuneExternalAdStateEntity.initial([
    String? source,
  ]) =>
      FortuneExternalAdStateEntity(
        source: source ?? '',
      );
}
