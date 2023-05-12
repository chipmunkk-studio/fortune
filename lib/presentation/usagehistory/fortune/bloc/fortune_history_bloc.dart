import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/presentation/markerhistory/mock_data.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'fortune_history.dart';

class FortuneHistoryBloc extends Bloc<FortuneHistoryEvent, FortuneHistoryState>
    with SideEffectBlocMixin<FortuneHistoryEvent, FortuneHistoryState, FortuneHistorySideEffect> {
  static const tag = "[CountryCodeBloc]";

  FortuneHistoryBloc() : super(FortuneHistoryState.initial()) {
    on<FortuneHistoryInit>(init);
  }

  FutureOr<void> init(FortuneHistoryInit event, Emitter<FortuneHistoryState> emit) async {
    // emit(
    //   state.copyWith(
    //     histories: historySampleList,
    //   ),
    // );
  }
}
