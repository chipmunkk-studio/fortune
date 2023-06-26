import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_mission_normal_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'missions.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState>
    with SideEffectBlocMixin<MissionsEvent, MissionsState, MissionsSideEffect> {
  static const tag = "[MissionsBloc]";

  final GetMissionNormalUseCase getAllMissionsUseCase;

  MissionsBloc({
    required this.getAllMissionsUseCase,
  }) : super(MissionsState.initial()) {
    on<MissionsInit>(init);
  }

  FutureOr<void> init(MissionsInit event, Emitter<MissionsState> emit) async {
    await getAllMissionsUseCase().then(
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
    );
  }
}
