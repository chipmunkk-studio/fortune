import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/request/request_sign_up_param.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:fortune/domain/supabase/usecase/check_verify_sms_time_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_up_or_in_use_case.dart';
import 'package:fortune/domain/supabase/usecase/verify_email_use_case.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'web_verify_code.dart';

class WebVerifyCodeBloc extends Bloc<WebVerifyCodeEvent, WebVerifyCodeState>
    with SideEffectBlocMixin<WebVerifyCodeEvent, WebVerifyCodeState, WebVerifyCodeSideEffect> {
  final VerifyEmailUseCase verifyEmailUseCase;
  final CheckVerifySmsTimeUseCase checkVerifySmsTimeUseCase;
  final SignUpOrInUseCase signUpOrInUseCase;
  static const tag = "[PhoneNumberBloc]";
  static const verifyTime = 180;

  WebVerifyCodeBloc({
    required this.verifyEmailUseCase,
    required this.checkVerifySmsTimeUseCase,
    required this.signUpOrInUseCase,
  }) : super(WebVerifyCodeState.initial()) {
    on<WebVerifyCodeInit>(init);
    on<WebVerifyCodeCountdown>(verifyCodeCountdown);
    on<WebVerifyCodeRequestVerifyCode>(requestVerifyCode);
    on<WebVerifyConfirm>(verifyConfirm);
    on<WebVerifyCodeInput>(
      verifyCodeInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
  }

  FutureOr<void> init(WebVerifyCodeInit event, Emitter<WebVerifyCodeState> emit) async {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
    await _requestSignUpOrIn(emit);
  }

  FutureOr<void> verifyCodeCountdown(WebVerifyCodeCountdown event, Emitter<WebVerifyCodeState> emit) {
    final nextTime = state.verifyTime - 1;
    emit(
      state.copyWith(
        verifyTime: nextTime,
        isRequestVerifyCodeEnable: nextTime == 0,
      ),
    );
  }

  FutureOr<void> verifyCodeInput(WebVerifyCodeInput event, Emitter<WebVerifyCodeState> emit) {
    emit(
      state.copyWith(
        verifyCode: event.verifyCode,
        isConfirmEnable: FortuneValidator.isValidVerifyCode(event.verifyCode),
      ),
    );
  }

  FutureOr<void> requestVerifyCode(WebVerifyCodeRequestVerifyCode event, Emitter<WebVerifyCodeState> emit) async {
    await _requestSignUpOrIn(emit);
  }

  FutureOr<void> verifyConfirm(WebVerifyConfirm event, Emitter<WebVerifyCodeState> emit) async {
    emit(state.copyWith(isLoginProcessing: true));

    // 테스트 계정 일 경우 바이 패스.
    if (state.isTestAccount) {
      produceSideEffect(WebVerifyCodeLandingRoute(AppRoutes.mainRoute));
      return;
    }

    await verifyEmailUseCase(
      RequestVerifyEmailParam(
        email: state.phoneNumber,
        verifyCode: state.verifyCode,
      ),
    ).then(
      (value) => value.fold(
        (l) {
          emit(state.copyWith(isLoginProcessing: false));
          produceSideEffect(WebVerifyCodeError(l));
        },
        (r) async {
          emit(state.copyWith(isLoginProcessing: false));
          produceSideEffect(WebVerifyCodeLandingRoute(AppRoutes.mainRoute));
        },
      ),
    );
  }

  _requestSignUpOrIn(Emitter<WebVerifyCodeState> emit) async {
    await signUpOrInUseCase(
      RequestSignUpParam(
        email: state.phoneNumber,
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(WebVerifyCodeError(l)),
        (r) {
          emit(
            state.copyWith(
              isRequestVerifyCodeEnable: false,
              verifyTime: verifyTime,
              isTestAccount: r,
            ),
          );
        },
      ),
    );
  }
}
