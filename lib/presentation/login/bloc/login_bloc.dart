import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_respository.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  static const tag = "[PhoneNumberBloc]";

  LoginBloc({
    required this.authRepository,
    required this.userRepository,
  }) : super(LoginState.initial()) {
    on<LoginInit>(init);
    on<LoginPhoneNumberInput>(
      phoneNumberInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<LoginVerifyCodeInput>(
      verifyCodeInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<LoginBottomButtonClick>(clickNextButton);
    on<LoginRequestVerifyCode>(requestVerifyCode);
    on<LoginRequestVerifyCodeCountdown>(verifyCodeCountdown);
  }

  FutureOr<void> init(LoginInit event, Emitter<LoginState> emit) {
    emit(LoginState.initial(event.phoneNumber));
  }

  FutureOr<void> phoneNumberInput(LoginPhoneNumberInput event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isButtonEnabled: FortuneValidator.isValidPhoneNumber(event.phoneNumber),
      ),
    );
  }

  FutureOr<void> verifyCodeInput(LoginVerifyCodeInput event, Emitter<LoginState> emit) {
    final newState = state.copyWith(verifyCode: event.verifyCode);
    emit(newState);
  }

  FutureOr<void> clickNextButton(LoginBottomButtonClick event, Emitter<LoginState> emit) async {
    final convertedPhoneNumber = _getConvertedPhoneNumber(state.phoneNumber);
    final currentStep = state.steppers[0];

    switch (currentStep) {
      // 폰 번호 입력 상태.
      case LoginStepper.phoneNumber:
        await userRepository.findUserByPhone(convertedPhoneNumber).then(
              (value) => value.fold(
                (l) {
                  // 회원가입을 할 수 없을 경우 에러를 보냄.
                  produceSideEffect(LoginError(l));
                },
                (r) async {
                  // 버튼 비활성화.
                  emit(state.copyWith(isButtonEnabled: false));
                  // 회원 등록이 되지 않았을 경우.
                  if (r == null) {
                    await authRepository.getTerms().then(
                          (value) => value.fold(
                            (l) => produceSideEffect(LoginError(l)),
                            (terms) => produceSideEffect(
                              LoginShowTermsBottomSheet(
                                terms,
                                convertedPhoneNumber,
                              ),
                            ),
                          ),
                        );
                  } else {
                    final nextState = state.copyWith(
                      steppers: [LoginStepper.signInWithOtp, ...state.steppers],
                      guideTitle: LoginGuideTitle.signInWithOtp,
                      isButtonEnabled: true,
                      isRequestVerifyCodeEnable: true,
                    );
                    emit(nextState);
                    produceSideEffect(LoginNextStep());
                  }
                },
              ),
            );
        break;

      case LoginStepper.signInWithOtp:
        await authRepository
            .verifyPhoneNumber(
              otpCode: state.verifyCode,
              phoneNumber: _getConvertedPhoneNumber(state.phoneNumber),
            )
            .then(
              (value) => value.fold(
                (l) => produceSideEffect(LoginError(l)),
                (r) => produceSideEffect(LoginLandingRoute(Routes.homeRoute)),
              ),
            );
        break;
      default:
        break;
    }
  }

  FutureOr<void> requestVerifyCode(LoginRequestVerifyCode event, Emitter<LoginState> emit) async {
    final convertedPhoneNumber = _getConvertedPhoneNumber(state.phoneNumber);
    await userRepository.findUserByPhone(convertedPhoneNumber).then(
          (value) => value.fold(
            (l) => produceSideEffect(LoginError(l)),
            (r) async {
              if (r != null) {
                await authRepository
                    .signInWithOtp(
                      phoneNumber: _getConvertedPhoneNumber(state.phoneNumber),
                    )
                    .then(
                      (value) => value.fold(
                        (l) => produceSideEffect(LoginError(l)),
                        (r) async {
                          emit(
                            state.copyWith(
                              isRequestVerifyCodeEnable: false,
                              verifyTime: 10,
                            ),
                          );
                        },
                      ),
                    );
              } else {
                emit(state.copyWith(isButtonEnabled: false));
                await authRepository.signUp(phoneNumber: convertedPhoneNumber).then(
                      (value) => value.fold(
                        (l) => produceSideEffect(LoginError(l)),
                        (r) {
                          final nextState = state.copyWith(
                            steppers: [LoginStepper.signInWithOtp, ...state.steppers],
                            guideTitle: LoginGuideTitle.signInWithOtpNewMember,
                            isButtonEnabled: true,
                            isRequestVerifyCodeEnable: false,
                            verifyTime: 10,
                          );
                          emit(nextState);
                        },
                      ),
                    );
              }
            },
          ),
        );
  }

  FutureOr<void> verifyCodeCountdown(LoginRequestVerifyCodeCountdown event, Emitter<LoginState> emit) {
    final nextTime = state.verifyTime - 1;
    emit(
      state.copyWith(
        verifyTime: nextTime,
        isRequestVerifyCodeEnable: nextTime == 0,
      ),
    );
  }

  _getConvertedPhoneNumber(String phoneNumber) => phoneNumber.replaceFirst("0", "+82");
}
