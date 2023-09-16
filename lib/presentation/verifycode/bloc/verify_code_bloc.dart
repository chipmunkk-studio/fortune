import 'dart:async';
import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:foresh_flutter/domain/supabase/usecase/check_verify_sms_time_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/sign_up_or_in_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/verify_phone_number_use_case.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'verify_code.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState>
    with SideEffectBlocMixin<VerifyCodeEvent, VerifyCodeState, VerifyCodeSideEffect> {
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final CheckVerifySmsTimeUseCase checkVerifySmsTimeUseCase;
  final SignUpOrInUseCase signUpOrInUseCase;

  static const tag = "[PhoneNumberBloc]";
  static const verifyTime = 180;

  VerifyCodeBloc({
    required this.verifyPhoneNumberUseCase,
    required this.checkVerifySmsTimeUseCase,
    required this.signUpOrInUseCase,
  }) : super(VerifyCodeState.initial()) {
    on<VerifyCodeInit>(init);
    on<VerifyCodeCountdown>(verifyCodeCountdown);
    on<VerifyCodeRequestVerifyCode>(requestVerifyCode);
    on<VerifyConfirm>(verifyConfirm);
    on<VerifyCodeInput>(
      verifyCodeInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
  }

  FutureOr<void> init(VerifyCodeInit event, Emitter<VerifyCodeState> emit) async {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
    produceSideEffect(VerifyCodeSmsListening());
    await _requestSignUpOrIn(emit);
  }

  FutureOr<void> verifyCodeCountdown(VerifyCodeCountdown event, Emitter<VerifyCodeState> emit) {
    final nextTime = state.verifyTime - 1;
    emit(
      state.copyWith(
        verifyTime: nextTime,
        isRequestVerifyCodeEnable: nextTime == 0,
      ),
    );
  }

  FutureOr<void> verifyCodeInput(VerifyCodeInput event, Emitter<VerifyCodeState> emit) {
    emit(
      state.copyWith(
        verifyCode: event.verifyCode,
        isConfirmEnable: FortuneValidator.isValidVerifyCode(event.verifyCode),
      ),
    );
    if (event.isFromListening) {
      produceSideEffect(VerifyCodeInputFromSmsListening(event.verifyCode));
    }
  }

  FutureOr<void> requestVerifyCode(VerifyCodeRequestVerifyCode event, Emitter<VerifyCodeState> emit) async {
    await _requestSignUpOrIn(emit);
  }

  FutureOr<void> verifyConfirm(VerifyConfirm event, Emitter<VerifyCodeState> emit) async {
    await verifyPhoneNumberUseCase(
      RequestVerifyPhoneNumberParam(
        phoneNumber: state.phoneNumber,
        verifyCode: state.verifyCode,
      ),
    ).then(
      (value) => value.fold((l) {
        AppMetrica.reportEventWithJson('인증 실패', jsonEncode(l.toJsonMap()));
        produceSideEffect(VerifyCodeError(l));
      }, (r) {
        produceSideEffect(VerifyCodeLandingRoute(Routes.mainRoute));
      }),
    );
  }

  _requestSignUpOrIn(Emitter<VerifyCodeState> emit) async {
    await checkVerifySmsTimeUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(VerifyCodeError(l)),
        (r) async {
          await signUpOrInUseCase(state.phoneNumber).then(
            (value) => value.fold(
              (l) => produceSideEffect(VerifyCodeError(l)),
              (r) {
                emit(
                  state.copyWith(
                    isRequestVerifyCodeEnable: false,
                    verifyTime: verifyTime,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
