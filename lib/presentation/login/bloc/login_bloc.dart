import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/domain/supabase/request/request_sign_up_or_in_test_param.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_user_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/sign_up_or_in_with_test_use_case.dart';
import 'package:foresh_flutter/env.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  final GetUserUseCase getUserUseCase;
  final SignUpOrInWithTestUseCase signUpOrInWithTestUseCase;
  final Environment env;

  static const tag = "[PhoneNumberBloc]";

  LoginBloc({
    required this.getUserUseCase,
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
    // #0 문자 전송 때문에 앞에 +82 추가
    final convertedPhoneNumber = _getConvertedPhoneNumber(state.phoneNumber);

    await getUserUseCase(
      convertedPhoneNumber,
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(LoginError(l)),
        (r) async {
          final remoteConfig = env.remoteConfig;
          final client = Supabase.instance.client;

          // 사용자의 전화번호가 테스트 계정에 포함되어 있는지 확인.
          bool isTestAccount = remoteConfig.twilioTestPhoneNumber.contains(state.phoneNumber);

          // #1 테스트 계정 일 경우 인증번호 전송없이 회원가입/로그인 일괄 처리.
          if (isTestAccount) {
            await _handleTestAccountSignIn(remoteConfig, client);
            produceSideEffect(LoginLandingRoute(Routes.mainRoute));
            return;
          }

          // #2 가입된 사용자 인 경우 > 인증번호 전송 요구.
          if (r != null) {
            // 테스트 계정이 아닌 경우.
            emit(state.copyWith(guideTitle: LoginGuideTitle.signInWithOtp));
            produceSideEffect(LoginShowVerifyCodeBottomSheet(convertedPhoneNumber));
          } else {
            // #4 약관 바텀 시트를 보여줌.
            produceSideEffect(LoginShowTermsBottomSheet(convertedPhoneNumber));
          }
        },
      ),
    );
  }

  Future<void> _handleTestAccountSignIn(
    FortuneRemoteConfig config,
    SupabaseClient client,
  ) async {
    await signUpOrInWithTestUseCase(
      RequestSignUpOrInTestParam(
        testEmail: config.twilioTestAccountEmail,
        testPassword: config.twilioTestPassword,
        testPhoneNumber: config.twilioTestPhoneNumber,
      ),
    );
  }

  // 약관 동의 후 인증 번호 바텀시트 띄움.
  FutureOr<void> requestVerifyCode(LoginRequestVerifyCode event, Emitter<LoginState> emit) async {
    final convertedPhoneNumber = _getConvertedPhoneNumber(state.phoneNumber);
    produceSideEffect(LoginShowVerifyCodeBottomSheet(convertedPhoneNumber));
  }

  _getConvertedPhoneNumber(String phoneNumber) => '+82$phoneNumber';
}
