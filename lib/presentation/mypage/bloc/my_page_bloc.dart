import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/usecase/my_page_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/update_user_profile_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'my_page.dart';

class MyPageBloc extends Bloc<MyPageEvent, MyPageState>
    with SideEffectBlocMixin<MyPageEvent, MyPageState, MyPageSideEffect> {
  final MyPageUseCase myPageUseCase;
  final UpdateUserProfileUseCase updateProfileUseCase;

  MyPageBloc({
    required this.myPageUseCase,
    required this.updateProfileUseCase,
  }) : super(MyPageState.initial()) {
    on<MyPageInit>(init);
    on<MyPageUpdateProfile>(updateProfile);
  }

  FutureOr<void> init(MyPageInit event, Emitter<MyPageState> emit) async {
    await myPageUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MyPageError(l)),
        (r) {
          emit(
            state.copyWith(
              user: r.user,
              isAllowPushAlarm: r.isAllowPushAlarm,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> updateProfile(MyPageUpdateProfile event, Emitter<MyPageState> emit) async {
    await updateProfileUseCase(event.filePath).then(
      (value) => value.fold(
        (l) => produceSideEffect(MyPageError(l)),
        (r) {
          emit(
            state.copyWith(user: r),
          );
        },
      ),
    );
  }
}
