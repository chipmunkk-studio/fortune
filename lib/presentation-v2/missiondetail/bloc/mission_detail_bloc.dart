import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/entity/fortune_image_entity.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:fortune/domain/entity/mission_guide_entity.dart';
import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:fortune/domain/entity/reward_info_entity.dart';
import 'package:fortune/domain/usecase/mission_acquire_usecase.dart';
import 'package:fortune/domain/usecase/mission_detail_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'mission_detail.dart';

class MissionDetailBloc extends Bloc<MissionDetailEvent, MissionDetailState>
    with SideEffectBlocMixin<MissionDetailEvent, MissionDetailState, MissionDetailSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final MissionDetailUseCase missionDetailUseCase;
  final MissionAcquireUseCase missionAcquireUseCase;

  MissionDetailBloc({
    required this.missionDetailUseCase,
    required this.missionAcquireUseCase,
  }) : super(MissionDetailState.initial()) {
    on<MissionDetailInit>(init);
    on<MissionDetailExchange>(requestExchange);
  }

  FutureOr<void> init(
    MissionDetailInit event,
    Emitter<MissionDetailState> emit,
  ) async {
    await missionDetailUseCase(event.param.missionId).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionDetailError(l)),
        (r) async {
          emit(
            state.copyWith(
              entity: r,
              isLoading: false,
              isEnableButton: false,
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
    emit(state.copyWith(isRequestObtaining: true));
    await missionAcquireUseCase(
      state.entity.id,
      state.timestamp,
    ).then(
      (value) => value.fold(
        (l) {
          emit(state.copyWith(isRequestObtaining: false));
          produceSideEffect(MissionDetailError(l));
        },
        (r) async {
          emit(
            state.copyWith(
              isRequestObtaining: false,
              isEnableButton: false,
            ),
          );
          produceSideEffect(MissionDetailParticleBurst());
          await Future.delayed(const Duration(seconds: 1));
          produceSideEffect(MissionDetailAcquireSuccess(r));
        },
      ),
    );
  }
}
