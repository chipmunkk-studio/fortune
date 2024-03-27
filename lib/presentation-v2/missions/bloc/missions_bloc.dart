import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/usecase/mission_list_usecase.dart';
import 'package:fortune/domain/usecase/user_me_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'missions.dart';

class MissionsBloc extends Bloc<MissionsEvent, MissionsState>
    with SideEffectBlocMixin<MissionsEvent, MissionsState, MissionsSideEffect> {
  MissionListUseCase missionListUseCase;
  UserMeUseCase userMeUseCase;

  MissionsBloc({
    required this.missionListUseCase,
    required this.userMeUseCase,
  }) : super(MissionsState.initial()) {
    on<MissionsInit>(init);
  }

  FutureOr<void> init(MissionsInit event, Emitter<MissionsState> emit) async {
    await userMeUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionsError(l)),
        (r) => emit(
          state.copyWith(
            timestamps: r.timestamps,
          ),
        ),
      ),
    );
    await missionListUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MissionsError(l)),
        (r) {
          emit(
            state.copyWith(
              missions: r.list,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }
}
