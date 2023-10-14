import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/usecase/cancel_withdrawal_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_user_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_in_with_email_use_case.dart';
import 'package:fortune/env.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  final GetUserUseCase getUserUseCase;
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final CancelWithdrawalUseCase cancelWithdrawalUseCase;
  final Environment env;

  LoginBloc({
    required this.getUserUseCase,
    required this.cancelWithdrawalUseCase,
    required this.signInWithEmailUseCase,
    required this.env,
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
    on<LoginRequestCancelWithdrawal>(cancelWithdrawal);
  }

  FutureOr<void> init(LoginInit event, Emitter<LoginState> emit) async {
    FortuneLogger.info('현재 유저 상태: ${event.loginUserState.name}');
    emit(
      state.copyWith(
        loginUserState: event.loginUserState,
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
    await getUserUseCase(
      state.email,
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(LoginError(l)),
        (r) async {
          // 회원 탈퇴 여부.
          if (r != null && r.isWithdrawal) {
            produceSideEffect(LoginWithdrawalUser(r.isEnableReSignIn));
            return;
          }
          // 사용자가 가입되어 있으면 인증번호 전송 로직을 처리
          if (r != null) {
            // 인증번호 전송
            emit(state.copyWith(guideTitle: LoginGuideTitle.signInWithOtp));
            produceSideEffect(LoginShowVerifyCodeBottomSheet(state.email));
          } else {
            // 약관 바텀 시트 표시
            produceSideEffect(
              LoginShowTermsBottomSheet(
                state.email,
              ),
            );
          }
        },
      ),
    );
  }

  // 약관 동의 후 인증 번호 바텀시트 띄움.
  FutureOr<void> requestVerifyCode(LoginRequestVerifyCode event, Emitter<LoginState> emit) async {
    produceSideEffect(LoginShowVerifyCodeBottomSheet(state.email));
  }

  FutureOr<void> cancelWithdrawal(LoginRequestCancelWithdrawal event, Emitter<LoginState> emit) async {
    await cancelWithdrawalUseCase(state.email).then(
      (value) => value.fold(
        (l) => produceSideEffect(LoginError(l)),
        (r) async {
          await _processSignInOrUp(emit);
        },
      ),
    );
  }
}
