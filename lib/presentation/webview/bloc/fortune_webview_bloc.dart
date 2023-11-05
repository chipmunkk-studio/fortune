import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'fortune_webview.dart';

class FortuneWebviewBloc extends Bloc<FortuneWebviewEvent, FortuneWebviewState>
    with SideEffectBlocMixin<FortuneWebviewEvent, FortuneWebviewState, FortuneWebviewSideEffect> {
  FortuneWebviewBloc() : super(FortuneWebviewState.initial()) {
    on<FortuneWebviewInit>(init);
  }

  FutureOr<void> init(FortuneWebviewInit event, Emitter<FortuneWebviewState> emit) async {}
}
