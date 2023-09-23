import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/usecase/nick_name_use_case.dart';
import 'package:fortune/domain/supabase/usecase/update_user_profile_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'nick_name.dart';

class NickNameBloc extends Bloc<NickNameEvent, NickNameState>
    with SideEffectBlocMixin<NickNameEvent, NickNameState, NickNameSideEffect> {
  final NickNameUseCase nickNameUseCase;
  final UpdateUserProfileUseCase updateProfileUseCase;

  NickNameBloc({
    required this.nickNameUseCase,
    required this.updateProfileUseCase,
  }) : super(NickNameState.initial()) {
    on<NickNameInit>(init);
    on<NickNameUpdateProfile>(updateProfile);
    on<NickNameTextInput>(
      nickNameTextInput,
      transformer: debounce(const Duration(microseconds: 200)),
    );
  }

  FutureOr<void> init(NickNameInit event, Emitter<NickNameState> emit) async {
    await nickNameUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(NickNameError(l)),
        (r) {
          emit(
            state.copyWith(
              userEntity: r.user,
              nickName: r.user.nickname,
            ),
          );
          produceSideEffect(NickNameUserInfoInit(r.user));
        },
      ),
    );
  }

  FutureOr<void> updateProfile(NickNameUpdateProfile event, Emitter<NickNameState> emit) async {
    await updateProfileUseCase(event.filePath).then(
      (value) => value.fold(
        (l) => produceSideEffect(NickNameError(l)),
        (r) {
          emit(
            state.copyWith(userEntity: r),
          );
        },
      ),
    );
  }

  FutureOr<void> nickNameTextInput(NickNameTextInput event, Emitter<NickNameState> emit) {
    emit(
      state.copyWith(
        nickName: event.text,
        isButtonEnabled: FortuneValidator.isValidNickName(event.text),
      ),
    );
  }
}
