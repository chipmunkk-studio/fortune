import 'package:fortune/core/util/logger.dart';

import 'fortune_ad_source.dart';
import 'fortune_ad_state_entity.dart';

class FortuneAdManager {
  List<AdSourceType> priorityOrder;

  FortuneAdManager({
    required this.priorityOrder,
  });

  Future<FortuneAdState?> loadAd() async {
    for (var priority in priorityOrder) {
      try {
        var adSource = _createAdSourceBasedOnPriority(priority);
        return await adSource.loadAd();
      } catch (e) {
        FortuneLogger.error(message: e.toString());
        continue; // 실패 시 다음 우선 순위로 넘어갑니다.
      }
    }

    /// 모든 광고 로딩 실패 시.
    return null;
  }

  FortuneAdSource _createAdSourceBasedOnPriority(AdSourceType priority) {
    switch (priority) {
      case AdSourceType.AdMob:
        return AdMobAdSource();
      case AdSourceType.Custom:
        return CustomAdSource();
      case AdSourceType.External:
        return ExternalAdSource();
      default:
        return AdMobAdSource();
    }
  }
}
