import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/get_alarm_reward_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'alarm_reward.dart';

class AlarmRewardBloc extends Bloc<AlarmRewardEvent, AlarmRewardState>
    with SideEffectBlocMixin<AlarmRewardEvent, AlarmRewardState, AlarmRewardSideEffect> {
  final GetAlarmRewardUseCase getAlarmRewardUseCase;

  AlarmRewardBloc({
    required this.getAlarmRewardUseCase,
  }) : super(AlarmRewardState.initial()) {
    on<AlarmRewardInit>(init);
  }

  FutureOr<void> init(AlarmRewardInit event, Emitter<AlarmRewardState> emit) async {
    await getAlarmRewardUseCase(event.rewardId).then(
      (value) => value.fold(
        (l) => produceSideEffect(AlarmRewardError(l)),
        (r) {
          emit(state.copyWith(reward: r));
        },
      ),
    );
  }
}
