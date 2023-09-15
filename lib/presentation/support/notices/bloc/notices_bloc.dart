import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_notices_usecase.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'notices.dart';

class NoticesBloc extends Bloc<NoticesEvent, NoticesState>
    with SideEffectBlocMixin<NoticesEvent, NoticesState, NoticesSideEffect> {
  final GetNoticesUseCase getNoticesUseCase;

  NoticesBloc({
    required this.getNoticesUseCase,
  }) : super(NoticesState.initial()) {
    on<NoticesInit>(init);
  }

  FutureOr<void> init(NoticesInit event, Emitter<NoticesState> emit) async {
    await getNoticesUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(NoticesError(l)),
        (r) {
          emit(
            state.copyWith(
              items: r,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }
}
