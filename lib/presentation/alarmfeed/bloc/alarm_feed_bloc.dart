import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'alarm_feed.dart';

class AlarmFeedBloc extends Bloc<AlarmFeedEvent, AlarmFeedState>
    with SideEffectBlocMixin<AlarmFeedEvent, AlarmFeedState, AlarmFeedSideEffect> {
  AlarmFeedBloc() : super(AlarmFeedState.initial()) {
    on<AlarmFeedInit>(init);
  }

  FutureOr<void> init(AlarmFeedInit event, Emitter<AlarmFeedState> emit) async {}
}
