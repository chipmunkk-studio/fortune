import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/usecases/obtain_mission_detail_usecase.dart';
import 'package:foresh_flutter/domain/usecases/request_mission_exchange_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'mission_detail.dart';

class MissionDetailBloc extends Bloc<MissionDetailEvent, MissionDetailState>
    with SideEffectBlocMixin<MissionDetailEvent, MissionDetailState, MissionDetailSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final ObtainMissionDetailUseCase obtainMissionDetailUseCase;
  final RequestRewardExchangeUseCase requestRewardExchangeUseCase;

  MissionDetailBloc({
    required this.obtainMissionDetailUseCase,
    required this.requestRewardExchangeUseCase,
  }) : super(MissionDetailState.initial()) {
    on<MissionDetailInit>(init);
    on<MissionDetailExchange>(requestExchange);
  }

  FutureOr<void> init(
    MissionDetailInit event,
    Emitter<MissionDetailState> emit,
  ) async {
    await obtainMissionDetailUseCase(event.id).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailError(l)),
        (r) {
          emit(
            state.copyWith(
              rewardImage: r.imageUrl,
              name: r.name,
              missionId: event.id,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> requestExchange(
    MissionDetailExchange event,
    Emitter<MissionDetailState> emit,
  ) async {
    await requestRewardExchangeUseCase(state.missionId).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailError(l)),
        (r) {
          produceSideEffect(MissionClearSuccess());
        },
      ),
    );
  }
}
