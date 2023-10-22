import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/get_alarm_feed_use_case.dart';
import 'package:fortune/domain/supabase/usecase/receive_alarm_reward_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'alarm_feed.dart';

class AlarmFeedBloc extends Bloc<AlarmFeedEvent, AlarmFeedState>
    with SideEffectBlocMixin<AlarmFeedEvent, AlarmFeedState, AlarmFeedSideEffect> {
  final GetAlarmFeedUseCase getAlarmFeedUseCase;
  final ReceiveAlarmRewardUseCase receiveAlarmRewardUseCase;

  AlarmFeedBloc({
    required this.getAlarmFeedUseCase,
    required this.receiveAlarmRewardUseCase,
  }) : super(AlarmFeedState.initial()) {
    on<AlarmRewardInit>(init);
    on<AlarmRewardReceive>(
      _receive,
      transformer: throttle(const Duration(seconds: 3)),
    );
  }

  FutureOr<void> init(AlarmRewardInit event, Emitter<AlarmFeedState> emit) async {
    await getAlarmFeedUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(AlarmFeedError(l)),
        (r) async {
          emit(
            state.copyWith(
              feeds: r,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> _receive(AlarmRewardReceive event, Emitter<AlarmFeedState> emit) async {
    emit(state.copyWith(isReceiving: true));
    await receiveAlarmRewardUseCase(event.entity).then(
      (value) => value.fold(
        (l) => produceSideEffect(AlarmFeedError(l)),
        (r) async {
          emit(
            state.copyWith(
              feeds: r,
              isLoading: false,
              isReceiving: false,
            ),
          );
          produceSideEffect(AlarmFeedReceiveConfetti());
          produceSideEffect(AlarmFeedReceiveShowDialog(event.entity));
        },
      ),
    );
  }
}
