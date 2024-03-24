import 'fortune_ad_source.dart';
import 'fortune_ad_state_entity.dart';

class FortuneAdManager {
  List<AdSourcePriority> priorityOrder;

  FortuneAdManager({
    required this.priorityOrder,
  });

  Future<FortuneAdState?> loadAd() async {
    for (var priority in priorityOrder) {
      try {
        var adSource = _createAdSourceBasedOnPriority(priority);
        if (adSource != null) {
          return await adSource.loadAd();
        }
      } catch (e) {
        continue; // 실패 시 다음 우선 순위로 넘어갑니다.
      }
    }

    /// 모든 광고 로딩 실패 시.
    return null;
  }

  FortuneAdSource? _createAdSourceBasedOnPriority(AdSourcePriority priority) {
    switch (priority) {
      case AdSourcePriority.AdMob:
        return AdMobAdSource();
      case AdSourcePriority.Custom:
        return CustomAdSource();
      case AdSourcePriority.External:
        return ExternalAdSource();
      default:
        return null;
    }
  }
}

extension FortuneAdManagerExt on FortuneAdState? {
  showAd(Function callback) {
    if (this is FortuneAdmobAdStateEntity) {
      final adState = this as FortuneAdmobAdStateEntity; // 타입 캐스팅
      adState.rewardedAd?.show(onUserEarnedReward: (_, __) => callback());
    } else if (this is FortuneCustomAdStateEntity) {
      callback();
    } else if (this is FortuneExternalAdStateEntity) {
      callback();
    }
  }
}
