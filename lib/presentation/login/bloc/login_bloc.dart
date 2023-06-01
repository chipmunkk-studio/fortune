import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/network/credential/token_response.dart';
import 'package:foresh_flutter/core/network/credential/user_credential.dart';
import 'package:foresh_flutter/core/notification/notification_manager.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/domain/entities/agree_terms_entity.dart';
import 'package:foresh_flutter/domain/usecases/obtain_sms_verify_code.dart';
import 'package:foresh_flutter/domain/usecases/obtain_terms_usecase.dart';
import 'package:foresh_flutter/domain/usecases/sms_verify_code_confirm_usecase.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:single_item_storage/storage.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  static const tag = "[PhoneNumberBloc]";

  final ObtainSmsVerifyCodeUseCase obtainSmsVerifyCodeUseCase;
  final ObtainTermsUseCase obtainTermsUseCase;
  final SmsVerifyCodeConfirmUseCase smsVerifyCodeConfirmUseCase;
  final Storage<UserCredential> userStorage;
  final FortuneNotificationsManager fcmManager;

  LoginBloc({
    required this.obtainSmsVerifyCodeUseCase,
    required this.smsVerifyCodeConfirmUseCase,
    required this.obtainTermsUseCase,
    required this.userStorage,
    required this.fcmManager,
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
    final newState = state.copyWith(
      verifyCode: event.verifyCode,
      isButtonEnabled: FortuneValidator.isValidVerifyCode(event.verifyCode),
    );
    emit(newState);
  }

  FutureOr<void> clickNextButton(LoginBottomButtonClick event, Emitter<LoginState> emit) async {
    switch (state.steppers[0]) {
      // 폰 번호 입력 상태.
      case LoginStepper.phoneNumber:
        final nextState = state.copyWith(
          steppers: [LoginStepper.signInWithOtp, ...state.steppers],
          guideTitle: LoginGuideTitle.signInWithOtp,
          isButtonEnabled: false,
          isRequestVerifyCodeEnable: true,
        );
        emit(nextState);
        produceSideEffect(LoginNextStep());
        break;
      // 인증 번호 입력 화면.
      case LoginStepper.signInWithOtp:
        await smsVerifyCodeConfirmUseCase(
          RequestConfirmSmsVerifyCodeParams(
            phoneNumber: state.phoneNumber,
            authenticationNumber: int.parse(state.verifyCode),
            pushToken: await fcmManager.getFcmPushToken(),
          ),
        ).then(
          (value) => value.fold(
            (l) => produceSideEffect(LoginError(l)),
            (r) async {
              UserCredential credential = await userStorage.get() ?? UserCredential.initial();
              var saveCredential = await userStorage.save(
                credential.copy(
                  token: TokenResponse(
                    accessToken: r.accessToken,
                    refreshToken: r.refreshToken,
                  ),
                ),
              );
              produceSideEffect(
                LoginLandingRoute(
                  r.registered ? Routes.mainRoute : Routes.loginCompleteRoute,
                ),
              );
            },
          ),
        );
        break;
      default:
        break;
    }
  }

  FutureOr<void> requestVerifyCode(LoginRequestVerifyCode event, Emitter<LoginState> emit) async {
    await obtainTermsUseCase(state.phoneNumber).then(
      (value) => value.fold(
        (l) => produceSideEffect(LoginError(l)),
        (r) async {
          if (r.terms.isEmpty || event.isTermsAgree) {
            await obtainSmsVerifyCodeUseCase(
              RequestSmsVerifyCodeParams(
                phoneNumber: state.phoneNumber,
              ),
            ).then(
              (value) => value.fold(
                (l) => produceSideEffect(LoginError(l)),
                (r) {
                  emit(
                    state.copyWith(
                      isRequestVerifyCodeEnable: false,
                      verifyTime: 30,
                    ),
                  );
                  produceSideEffect(LoginShowSnackBar("인증 번호 요청 성공"));
                },
              ),
            );
          } else {
            final terms = r.terms.map((e) => AgreeTermsEntity(title: e.title, content: e.content)).toList();
            produceSideEffect(
              LoginShowTermsBottomSheet(
                terms: terms,
                phoneNumber: state.phoneNumber,
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
}
