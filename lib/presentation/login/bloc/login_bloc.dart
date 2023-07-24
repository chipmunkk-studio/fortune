import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_user_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/sign_up_or_in_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/verify_phone_number_use_case.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  final GetUserUseCase getUserUseCase;
  final SignUpOrInUseCase signUpOrInUseCase;

  static const tag = "[PhoneNumberBloc]";

  LoginBloc({
    required this.getUserUseCase,
    required this.signUpOrInUseCase,
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
          // #2 가입된 사용자 인 경우 > 인증번호 전송 요구.
          if (r != null) {
            await signUpOrInUseCase(convertedPhoneNumber).then(
              (value) => value.fold(
                (l) => produceSideEffect(LoginError(l)),
                (r) {
                  emit(state.copyWith(guideTitle: LoginGuideTitle.signInWithOtp));
                  produceSideEffect(LoginShowVerifyCodeBottomSheet());
                },
              ),
            );
          }
          // #3 가입된 사용자가 아닌 경우.
          else {
            // #4 약관 바텀 시트를 보여줌.
            produceSideEffect(LoginShowTermsBottomSheet(convertedPhoneNumber));
          }
        },
      ),
    );
  }

  // 약관 동의 후 인증 번호 요청.
  FutureOr<void> requestVerifyCode(LoginRequestVerifyCode event, Emitter<LoginState> emit) async {
    final convertedPhoneNumber = _getConvertedPhoneNumber(state.phoneNumber);
    produceSideEffect(LoginShowVerifyCodeBottomSheet());
    // await signUpOrInUseCase(convertedPhoneNumber).then(
    //   (value) => value.fold(
    //     (l) => produceSideEffect(LoginError(l)),
    //     (r) {
    //       emit(
    //         state.copyWith(
    //           currentStep: LoginStep.signInWithOtp,
    //           guideTitle: LoginGuideTitle.signInWithOtpNewMember,
    //           isRequestVerifyCodeEnable: false,
    //           verifyTime: 10,
    //         ),
    //       );
    //       // produceSideEffect(LoginShowVerifyCodeBottomSheet());
    //     },
    //   ),
    // );
  }

  _getConvertedPhoneNumber(String phoneNumber) => phoneNumber.replaceFirst("0", "+82");
}
