import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/usecases/obtain_reward_product_detail_usecase.dart';
import 'package:foresh_flutter/domain/usecases/request_reward_exchange_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'reward_detail.dart';

class RewardDetailBloc extends Bloc<RewardDetailEvent, RewardDetailState>
    with SideEffectBlocMixin<RewardDetailEvent, RewardDetailState, RewardDetailSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final ObtainRewardProductDetailUseCase obtainRewardProductDetailUseCase;
  final RequestRewardExchangeUseCase requestRewardExchangeUseCase;

  RewardDetailBloc({
    required this.obtainRewardProductDetailUseCase,
    required this.requestRewardExchangeUseCase,
  }) : super(RewardDetailState.initial()) {
    on<RewardDetailInit>(init);
    on<RewardDetailExchange>(requestExchange);
  }

  FutureOr<void> init(
    RewardDetailInit event,
    Emitter<RewardDetailState> emit,
  ) async {
    await obtainRewardProductDetailUseCase(event.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(RewardDetailInventoryError(l)),
        (r) {
          emit(
            state.copyWith(
              rewardImage: r.imageUrl,
              name: r.name,
              rewardId: event.id,
              haveMarkers: r.exchangeableMarkers,
              notices: r.notices,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> requestExchange(
    RewardDetailExchange event,
    Emitter<RewardDetailState> emit,
  ) async {
    await requestRewardExchangeUseCase(state.rewardId).then(
      (value) => value.fold(
        (l) => produceSideEffect(RewardDetailInventoryError(l)),
        (r) {
          produceSideEffect(RewardDetailExchangeSuccess());
        },
      ),
    );
  }
}
