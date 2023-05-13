import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/usecases/obtain_reward_products_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'reward_list.dart';

class RewardListBloc extends Bloc<RewardListEvent, RewardListState>
    with SideEffectBlocMixin<RewardListEvent, RewardListState, RewardListSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final ObtainRewardProductsUseCase obtainRewardProductsUseCase;

  RewardListBloc({
    required this.obtainRewardProductsUseCase,
  }) : super(RewardListState.initial()) {
    on<RewardListInit>(init);
    on<RewardListChangeCheckStatus>(changeCheckStatus);
  }

  FutureOr<void> init(RewardListInit event, Emitter<RewardListState> emit) async {
    await obtainRewardProductsUseCase(0).then(
      (value) => value.fold(
        (l) => produceSideEffect(RewardListError(l)),
        (r) {
          emit(
            state.copyWith(
              totalMarkerCount: r.totalMarkerCount,
              markers: r.markers,
              rewards: r.rewards,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> changeCheckStatus(RewardListChangeCheckStatus event, Emitter<RewardListState> emit) {
    emit(state.copyWith(isChangeableChecked: !state.isChangeableChecked));
  }
}
