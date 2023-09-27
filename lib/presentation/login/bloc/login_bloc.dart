import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/request/request_sign_up_or_in_test_param.dart';
import 'package:fortune/domain/supabase/usecase/get_user_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_up_or_in_with_test_use_case.dart';
import 'package:fortune/domain/supabase/usecase/withdrawal_use_case.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  final GetUserUseCase getUserUseCase;
  final SignUpOrInWithTestUseCase signUpOrInWithTestUseCase;
  final WithdrawalUseCase withdrawalUseCase;
  final Environment env;

  _getConvertedPhoneNumber(String phoneNumber) => '82$phoneNumber';

  LoginBloc({
    required this.getUserUseCase,
    required this.withdrawalUseCase,
    required this.signUpOrInWithTestUseCase,
    required this.env,
  }) : super(LoginState.initial()) {
    on<LoginInit>(init);
    on<LoginPhoneNumberInput>(
      phoneNumberInput,
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
    emit(state.copyWith(loginUserState: event.loginUserState));
  }

  FutureOr<void> phoneNumberInput(LoginPhoneNumberInput event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isButtonEnabled: FortuneValidator.isValidPhoneNumber(event.phoneNumber),
      ),
    );
  }

  FutureOr<void> clickNextButton(LoginBottomButtonClick event, Emitter<LoginState> emit) async {
    final remoteConfig = env.remoteConfig;
    // 사용자의 전화번호가 테스트 계정에 포함되어 있는지 확인.
    bool isTestAccount = remoteConfig.twilioTestPhoneNumber.contains(state.phoneNumber);

    // #1 테스트 계정 일 경우 인증번호 전송없이 회원가입/로그인 일괄 처리.
    if (isTestAccount) {
      await _processTestSignInOrUp(remoteConfig);
    } else {
      await _processSignInOrUp(emit);
    }
  }

  Future<void> _processSignInOrUp(
    Emitter<LoginState> emit, {
    bool cancelWithdrawal = false,
  }) async {
    final convertedPhoneNumber = _getConvertedPhoneNumber(state.phoneNumber);

    await getUserUseCase(
      convertedPhoneNumber,
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(LoginError(l)),
        (r) async {
          // 회원 탈퇴 여부.
          if (r != null && r.isWithdrawal && !cancelWithdrawal) {
            produceSideEffect(LoginWithdrawalUser(r.isEnableReSignIn));
            return;
          }

          // 사용자가 가입되어 있으면 인증번호 전송 로직을 처리
          if (r != null) {
            // 인증번호 전송
            emit(state.copyWith(guideTitle: LoginGuideTitle.signInWithOtp));
            produceSideEffect(LoginShowVerifyCodeBottomSheet(convertedPhoneNumber));
          } else {
            // 약관 바텀 시트 표시
            produceSideEffect(LoginShowTermsBottomSheet(convertedPhoneNumber));
          }
        },
      ),
    );
  }

  Future<void> _processTestSignInOrUp(
    FortuneRemoteConfig config,
  ) async {
    await signUpOrInWithTestUseCase(
      RequestSignUpOrInTestParam(
        testEmail: config.twilioTestAccountEmail,
        testPassword: config.twilioTestPassword,
        testPhoneNumber: config.twilioTestPhoneNumber,
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(LoginError(l)),
        (r) {
          produceSideEffect(LoginLandingRoute(Routes.mainRoute));
        },
      ),
    );
  }

  // 약관 동의 후 인증 번호 바텀시트 띄움.
  FutureOr<void> requestVerifyCode(LoginRequestVerifyCode event, Emitter<LoginState> emit) async {
    final convertedPhoneNumber = _getConvertedPhoneNumber(state.phoneNumber);
    produceSideEffect(LoginShowVerifyCodeBottomSheet(convertedPhoneNumber));
  }

  FutureOr<void> cancelWithdrawal(LoginRequestCancelWithdrawal event, Emitter<LoginState> emit) async {
    await _processSignInOrUp(
      emit,
      cancelWithdrawal: true,
    );
  }
}
