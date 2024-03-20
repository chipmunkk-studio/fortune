import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/usecase/request_email_verify_code_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  final RequestEmailVerifyCodeUseCase requestEmailVerifyCodeUseCase;

  LoginBloc({
    required this.requestEmailVerifyCodeUseCase,
  }) : super(LoginState.initial()) {
    on<LoginInit>(init);
    on<LoginEmailInput>(
      emailInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<LoginBottomButtonClick>(clickNextButton);
    on<LoginRequestVerifyCode>(requestVerifyCode);
  }

  FutureOr<void> init(LoginInit event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        isLoading: false,
      ),
    );
  }

  FutureOr<void> emailInput(LoginEmailInput event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        isButtonEnabled: FortuneValidator.isValidEmail(event.email),
      ),
    );
  }

  FutureOr<void> clickNextButton(LoginBottomButtonClick event, Emitter<LoginState> emit) async {
    await _processSignInOrUp(emit);
  }

  Future<void> _processSignInOrUp(Emitter<LoginState> emit) async {
    await requestEmailVerifyCodeUseCase(
      state.email,
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(LoginError(l)),
        (r) async {
          try {
            emit(state.copyWith(guideTitle: LoginGuideTitle.signInWithOtp));
            produceSideEffect(LoginShowVerifyCodeBottomSheet(state.email));
          } catch (e) {
            FortuneLogger.error(message: e.toString());
          }
        },
      ),
    );
  }

  // 약관 동의 후 인증 번호 바텀시트 띄움.
  FutureOr<void> requestVerifyCode(LoginRequestVerifyCode event, Emitter<LoginState> emit) async {
    produceSideEffect(LoginShowVerifyCodeBottomSheet(state.email));
  }
}
