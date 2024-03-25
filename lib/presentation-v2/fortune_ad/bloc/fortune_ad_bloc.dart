import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/domain/usecase/show_ad_complete_use_case.dart';
import 'package:fortune/presentation-v2/admanager/fortune_ad.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'fortune_ad.dart';

class FortuneAdBloc extends Bloc<FortuneAdEvent, FortuneAdViewState>
    with SideEffectBlocMixin<FortuneAdEvent, FortuneAdViewState, FortuneAdSideEffect> {
  final ShowAdCompleteUseCase showAdCompleteUseCase;
  final FortuneAdManager adManager;

  FortuneAdBloc({
    required this.showAdCompleteUseCase,
    required this.adManager,
  }) : super(FortuneAdViewState.initial()) {
    on<FortuneAdInit>(_init);
    on<FortuneAdShowComplete>(_onAdShowComplete);
  }

  FutureOr<void> _init(FortuneAdInit event, Emitter<FortuneAdViewState> emit) async {
    try {
      final param = event.param;
      emit(state.copyWith(ts: param.ts));
      // 광고 불러오기
      final adState = await adManager.loadAd();
      FortuneLogger.info("AdState:: $adState");
      if (adState != null) {
        if (adState is FortuneAdmobAdStateEntity) {
          produceSideEffect(FortuneShowAdmob(adState));
        } else if (adState is FortuneCustomAdStateEntity) {
          // todo 커스텀 광고.
        } else if (adState is FortuneExternalAdStateEntity) {
          // todo 외부 광고.
        }
      } else {
        emit(state.copyWith(isAdRequestError: true));
      }
    } catch (e) {
      FortuneLogger.error(message: e.toString());
      emit(state.copyWith(isAdRequestError: true));
    }
  }

  FutureOr<void> _onAdShowComplete(FortuneAdShowComplete event, Emitter<FortuneAdViewState> emit) async {
    await showAdCompleteUseCase(state.ts).then(
      (value) => value.fold(
        (l) => produceSideEffect(FortuneAdError(l)),
        (user) {
          produceSideEffect(FortuneAdShowCompleteReturn(user));
        },
      ),
    );
  }
}
