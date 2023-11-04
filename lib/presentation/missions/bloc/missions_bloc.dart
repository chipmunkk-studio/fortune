import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/domain/supabase/usecase/get_missions_use_case.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'missions.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState>
    with SideEffectBlocMixin<MissionsEvent, MissionsState, MissionsSideEffect> {
  static const tag = "[MissionsBloc]";

  final GetMissionsUseCase getAllMissionsUseCase;

  MissionsBloc({
    required this.getAllMissionsUseCase,
  }) : super(MissionsState.initial()) {
    on<MissionsBottomInit>(bottomInit);
    on<MissionsTopInit>(topInit);
    on<MissionsLoadBannerAd>(loadBannerAd);
  }

  FutureOr<void> bottomInit(MissionsBottomInit event, Emitter<MissionsState> emit) async {
    await getAllMissionsUseCase()
        .then(
          (value) => value.fold(
            (l) => produceSideEffect(MissionsError(l)),
            (r) {
              emit(
                state.copyWith(
                  missions: r,
                  isLoading: false,
                ),
              );
            },
          ),
        )
        .onError((error, stackTrace) => null);
  }

  FutureOr<void> topInit(MissionsTopInit event, Emitter<MissionsState> emit) {
    _loadBannerAd();
  }

  FutureOr<void> loadBannerAd(MissionsLoadBannerAd event, Emitter<MissionsState> emit) {
    emit(state.copyWith(ad: event.ad));
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => add(MissionsLoadBannerAd(ad as BannerAd?)),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }
}
