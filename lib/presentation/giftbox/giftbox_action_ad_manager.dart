import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/presentation/giftbox/bloc/giftbox_action_side_effect.dart';
import 'package:vungle/vungle.dart';

import 'giftbox_action_param.dart';

class GiftboxActionAdManager {
  final BuildContext context;
  final Function1<GiftboxActionParam, void> noAdAction;
  final Function2<GiftboxActionParam, String, void> showAdSuccess;

  GiftboxActionAdManager(
    this.context, {
    required this.noAdAction,
    required this.showAdSuccess,
  });

  /// Vungle 광고를 재생하거나, 준비되지 않았을 경우 AdMob 광고를 재생합니다.
  void _playVungleAd(GiftboxActionParam param) async {
    try {
      if (await Vungle.isAdPlayable(VungleAdHelper.rewardedAdUnitId)) {
        Vungle.playAd(VungleAdHelper.rewardedAdUnitId);
        Vungle.onAdRewardedListener = (_) => showAdSuccess(param, 'Vungle');
      } else {
        Vungle.loadAd(VungleAdHelper.rewardedAdUnitId);
        _showAdMobAd(param);
      }
    } catch (e) {
      noAdAction(param);
    }
  }

  /// 필요에 따라 적절한 광고(AdMob 또는 Vungle)를 표시합니다.
  void handleAdDisplay(GiftboxProcessShowAdAction sideEffect) {
    final param = sideEffect.param;
    final adMobStatus = sideEffect.adMobStatus;

    // 애드몹 상태가 false 이거나 광고가 없을 경우.
    if (!adMobStatus || param.ad == null) {
      _playVungleAd(param);
    } else {
      _showAdMobAd(param);
    }
  }

  /// AdMob 광고를 표시합니다. 광고가 준비되지 않았을 경우 noAdAction을 호출합니다.
  void _showAdMobAd(GiftboxActionParam param) {
    final admobAd = param.ad;
    if (admobAd != null) {
      admobAd.show(onUserEarnedReward: (_, reward) => showAdSuccess(param, 'Admob'));
    } else {
      noAdAction(param);
    }
  }
}
