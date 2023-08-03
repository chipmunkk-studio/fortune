import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_alarm_feed_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'alarm_feed.dart';

class AlarmFeedBloc extends Bloc<AlarmFeedEvent, AlarmFeedState>
    with SideEffectBlocMixin<AlarmFeedEvent, AlarmFeedState, AlarmFeedSideEffect> {
  final GetAlarmFeedUseCase getAlarmFeedUseCase;

  AlarmFeedBloc({
    required this.getAlarmFeedUseCase,
  }) : super(AlarmFeedState.initial()) {
    on<AlarmRewardInit>(init);
  }

  FutureOr<void> init(AlarmRewardInit event, Emitter<AlarmFeedState> emit) async {
    await getAlarmFeedUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(AlarmFeedError(l)),
        (r) {

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
}
