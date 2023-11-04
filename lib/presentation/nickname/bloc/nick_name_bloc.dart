import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/request/request_nickname_update_param.dart';
import 'package:fortune/domain/supabase/request/request_profile_update_param.dart';
import 'package:fortune/domain/supabase/usecase/nick_name_use_case.dart';
import 'package:fortune/domain/supabase/usecase/update_user_nick_name_use_case.dart';
import 'package:fortune/domain/supabase/usecase/update_user_profile_use_case.dart';
import 'package:fortune/domain/supabase/usecase/withdrawal_use_case.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'nick_name.dart';

class NickNameBloc extends Bloc<NickNameEvent, NickNameState>
    with SideEffectBlocMixin<NickNameEvent, NickNameState, NickNameSideEffect> {
  final NickNameUseCase nickNameUseCase;
  final UpdateUserProfileUseCase updateProfileUseCase;
  final WithdrawalUseCase withdrawalUseCase;
  final UpdateUserNickNameUseCase updateUserNickNameUseCase;

  NickNameBloc({
    required this.nickNameUseCase,
    required this.updateProfileUseCase,
    required this.withdrawalUseCase,
    required this.updateUserNickNameUseCase,
  }) : super(NickNameState.initial()) {
    on<NickNameInit>(init);
    on<NickNameUpdateProfile>(updateProfile);
    on<NickNameUpdateNickName>(updateNickName);
    on<NickNameSignOut>(signOut);
    on<NickNameWithdrawal>(withdrawal);
    on<NickNameTextInput>(
      nickNameTextInput,
      transformer: debounce(const Duration(microseconds: 200)),
    );
  }

  FutureOr<void> init(NickNameInit event, Emitter<NickNameState> emit) async {
    await nickNameUseCase()
        .then(
          (value) => value.fold(
            (l) => produceSideEffect(NickNameError(l)),
            (r) {
              emit(
                state.copyWith(
                  userEntity: r.user,
                  isLoading: false,
                  nickName: r.user.nickname,
                ),
              );
              produceSideEffect(NickNameUserInfoInit(r.user));
            },
          ),
        )
        .onError(
          (error, stackTrace) => FortuneLogger.error(
            message: error.toString(),
          ),
        );
  }

  FutureOr<void> updateProfile(NickNameUpdateProfile event, Emitter<NickNameState> emit) async {
    await updateProfileUseCase(
      RequestProfileUpdateParam(
        email: state.userEntity.email,
        profile: event.filePath,
      ),
    ).then(
      (value) => value.fold(
        (l) {
          produceSideEffect(NickNameError(l));
        },
        (r) {
          emit(state.copyWith(userEntity: r));
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

  FutureOr<void> updateNickName(NickNameUpdateNickName event, Emitter<NickNameState> emit) async {
    await updateUserNickNameUseCase(
      RequestNickNameUpdateParam(
        email: state.userEntity.email,
        nickName: state.nickName,
      ),
    ).then(
      (value) => value.fold(
        (l) {
          produceSideEffect(NickNameError(l));
        },
        (r) {
          produceSideEffect(NickNameRoutingPage(route: AppRoutes.myPageRoute));
        },
      ),
    );
  }

  FutureOr<void> signOut(NickNameSignOut event, Emitter<NickNameState> emit) async {
    emit(state.copyWith(isUpdating: true));
    await Supabase.instance.client.auth.signOut().then((value) async {
      emit(state.copyWith(isUpdating: false));
      produceSideEffect(
        NickNameRoutingPage(route: AppRoutes.loginRoute),
      );
    });
  }

  FutureOr<void> withdrawal(NickNameWithdrawal event, Emitter<NickNameState> emit) async {
    emit(state.copyWith(isUpdating: true));
    await withdrawalUseCase(state.userEntity.email).then(
      (value) => value.fold(
        (l) {
          emit(state.copyWith(isUpdating: false));
          produceSideEffect(NickNameError(l));
        },
        (r) async {
          emit(state.copyWith(isUpdating: false));
          produceSideEffect(
            NickNameRoutingPage(
              route: AppRoutes.loginRoute,
              isWithdrawal: true,
            ),
          );
        },
      ),
    );
  }
}
