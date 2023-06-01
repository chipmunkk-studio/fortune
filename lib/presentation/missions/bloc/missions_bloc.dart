import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/usecases/obtain_missions_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'missions.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState>
    with SideEffectBlocMixin<MissionsEvent, MissionsState, MissionsSideEffect> {
  static const tag = "[MissionsBloc]";

  final ObtainMissionsUseCase obtainMissionsUseCase;

  MissionsBloc({
    required this.obtainMissionsUseCase,
  }) : super(MissionsState.initial()) {
    on<MissionsInit>(init);
    on<MissionsTabSelected>(tabSelected);
  }

  FutureOr<void> init(MissionsInit event, Emitter<MissionsState> emit) async {
    await obtainMissionsUseCase(0).then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionsError(l)),
        (r) {
          emit(
            state.copyWith(isLoading: false, missions: r.missions),
          );
        },
      ),
    );
  }

  FutureOr<void> tabSelected(MissionsTabSelected event, Emitter<MissionsState> emit) {
    emit(
      state.copyWith(
        currentTab: () {
          if (event.select == 1) {
            return TabMission.ordinary;
          } else {
            return TabMission.round;
          }
        }(),
      ),
    );
  }
}
