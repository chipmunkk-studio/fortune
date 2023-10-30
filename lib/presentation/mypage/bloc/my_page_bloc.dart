import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/local/local_respository.dart';
import 'package:fortune/domain/supabase/request/request_profile_update_param.dart';
import 'package:fortune/domain/supabase/usecase/my_page_use_case.dart';
import 'package:fortune/domain/supabase/usecase/update_user_profile_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'my_page.dart';

class MyPageBloc extends Bloc<MyPageEvent, MyPageState>
    with SideEffectBlocMixin<MyPageEvent, MyPageState, MyPageSideEffect> {
  final MyPageUseCase myPageUseCase;
  final UpdateUserProfileUseCase updateProfileUseCase;
  final LocalRepository localRepository;

  MyPageBloc({
    required this.myPageUseCase,
    required this.updateProfileUseCase,
    required this.localRepository,
  }) : super(MyPageState.initial()) {
    on<MyPageInit>(init);
    on<MyPageUpdateProfile>(updateProfile);
    on<MyPageUpdatePushAlarm>(updatePushAlarm);
  }

  FutureOr<void> init(MyPageInit event, Emitter<MyPageState> emit) async {
    await myPageUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MyPageError(l)),
        (r) async {
          emit(
            state.copyWith(
              user: r.user,
              isAllowPushAlarm: r.isAllowPushAlarm,
              hasNewNotice: r.hasNewNotice,
              hasNewFaq: r.hasNewFaq,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> updateProfile(MyPageUpdateProfile event, Emitter<MyPageState> emit) async {
    await updateProfileUseCase(
      RequestProfileUpdateParam(
        email: state.user.email,
        profile: event.filePath,
      ),
    ).then(
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

  FutureOr<void> updatePushAlarm(MyPageUpdatePushAlarm event, Emitter<MyPageState> emit) async {
    final result = await localRepository.setAllowPushAlarm(!event.isOn);
    emit(state.copyWith(isAllowPushAlarm: result));
  }
}
