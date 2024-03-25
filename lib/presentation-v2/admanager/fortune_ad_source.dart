// 광고 소스 인터페이스
import 'dart:async';

import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'fortune_ad_state_entity.dart';

abstract class FortuneAdSource {
  Future<FortuneAdState> loadAd();
}

// AdMob 광고 소스 구현
class AdMobAdSource implements FortuneAdSource {
  int _rewardedAdRetryAttempt = 1;

  static AdSourceType stringToAdSourcePriority(String priorityString) {
    switch (priorityString) {
      case 'AdMob':
        return AdSourceType.AdMob;
      case 'Custom':
        return AdSourceType.Custom;
      case 'External':
        return AdSourceType.External;
      default:
        return AdSourceType.None;
    }
  }

  @override
  Future<FortuneAdState> loadAd() async {
    Completer<FortuneAdState> completer = Completer<FortuneAdState>();
    try {
      RewardedAd.load(
        adUnitId: AdmobHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAdRetryAttempt = 1;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // 사용자가 광고를 닫았을 경우.
              onAdDismissedFullScreenContent: (ad) {},
              // 광고가 사용자에게 표시되기 시작했을 경우
              onAdShowedFullScreenContent: (ad) {},
              // 광고 표시에 실패 했을 경우
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                completer.completeError("광고 로딩 실패: ${error.message}");
              },
            );
            FortuneLogger.info("광고 로딩 성공");
            completer.complete(FortuneAdmobAdStateEntity(rewardedAd: ad));
          },
          onAdFailedToLoad: (err) async {
            FortuneLogger.error(message: "광고 로딩 실패 : $err");
            completer.completeError("광고 로딩 실패: $err");
          },
        ),
      );
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError("광고 로딩 실패: $e");
      }
    }
    return completer.future;
  }
}

// 커스텀 광고 소스 구현
class CustomAdSource implements FortuneAdSource {
  @override
  Future<FortuneAdState> loadAd() async {
    Completer<FortuneAdState> completer = Completer<FortuneAdState>();
    completer.completeError("CustomAdSource:: 광고가 없습니다");
    return completer.future;
  }
}

// 외부 광고 소스 구현
class ExternalAdSource implements FortuneAdSource {
  @override
  Future<FortuneAdState> loadAd() async {
    Completer<FortuneAdState> completer = Completer<FortuneAdState>();
    completer.completeError("ExternalAdSource:: 광고가 없습니다");
    return completer.future;
    // 외부 광고 로딩 로직 구현
  }
}
