import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/usecase/cancel_withdrawal_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_country_info_use_case.dart';
import 'package:fortune/domain/supabase/usecase/get_user_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_in_with_email_use_case.dart';
import 'package:fortune/env.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'web_login.dart';

class WebLoginBloc extends Bloc<WebLoginEvent, WebLoginState>
    with SideEffectBlocMixin<WebLoginEvent, WebLoginState, WebLoginSideEffect> {
  final GetUserUseCase getUserUseCase;
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final CancelWithdrawalUseCase cancelWithdrawalUseCase;
  final Environment env;

  WebLoginBloc({
    required this.getUserUseCase,
    required this.cancelWithdrawalUseCase,
    required this.signInWithEmailUseCase,
    required this.env,
  }) : super(WebLoginState.initial()) {
    on<WebLoginInit>(init);
    on<WebLoginEmailInput>(
      emailInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<WebLoginBottomButtonClick>(clickNextButton);
    on<WebLoginRequestVerifyCode>(requestVerifyCode);
    on<WebLoginRequestCancelWithdrawal>(cancelWithdrawal);
  }

  FutureOr<void> init(WebLoginInit event, Emitter<WebLoginState> emit) async {
    emit(state.copyWith(isLoading: false));
  }

  FutureOr<void> emailInput(WebLoginEmailInput event, Emitter<WebLoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        isButtonEnabled: FortuneValidator.isValidEmail(event.email),
      ),
    );
  }

  FutureOr<void> clickNextButton(WebLoginBottomButtonClick event, Emitter<WebLoginState> emit) async {
    await _processSignInOrUp(emit);
  }

  Future<void> _processSignInOrUp(Emitter<WebLoginState> emit) async {
    await getUserUseCase(
      state.email,
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(WebLoginError(l)),
        (r) async {
          // 회원 탈퇴 여부.
          if (r != null && r.isWithdrawal) {
            produceSideEffect(WebLoginWithdrawalUser(r.isEnableReSignIn));
            return;
          }
          // 사용자가 가입되어 있으면 인증번호 전송 로직을 처리
          if (r != null) {
            // 인증번호 전송
            produceSideEffect(WebLoginShowVerifyCodeBottomSheet(state.email));
          } else {
            // 약관 바텀 시트 표시
            produceSideEffect(
              WebLoginShowTermsBottomSheet(
                state.email,
              ),
            );
          }
        },
      ),
    );
  }

  // 약관 동의 후 인증 번호 바텀시트 띄움.
  FutureOr<void> requestVerifyCode(WebLoginRequestVerifyCode event, Emitter<WebLoginState> emit) async {
    produceSideEffect(WebLoginShowVerifyCodeBottomSheet(state.email));
  }

  FutureOr<void> cancelWithdrawal(WebLoginRequestCancelWithdrawal event, Emitter<WebLoginState> emit) async {
    await cancelWithdrawalUseCase(state.email).then(
      (value) => value.fold(
        (l) => produceSideEffect(WebLoginError(l)),
        (r) async {
          await _processSignInOrUp(emit);
        },
      ),
    );
  }
}
