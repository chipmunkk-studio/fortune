import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/my_missions_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'my_missions.dart';

class MyMissionsBloc extends Bloc<MyMissionsEvent, MyMissionsState>
    with SideEffectBlocMixin<MyMissionsEvent, MyMissionsState, MyMissionsSideEffect> {
  final MyMissionsUseCase missionsUseCase;

  MyMissionsBloc({
    required this.missionsUseCase,
  }) : super(MyMissionsState.initial()) {
    on<MyMissionsInit>(init);
  }

  FutureOr<void> init(MyMissionsInit event, Emitter<MyMissionsState> emit) async {
    await missionsUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MyMissionsError(l)),
        (r) {
          emit(
            state.copyWith(
              missions: r.missions,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }
}
