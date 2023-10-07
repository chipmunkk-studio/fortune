import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/request/request_sign_up_param.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:fortune/domain/supabase/usecase/cancel_withdrawal_use_case.dart';
import 'package:fortune/domain/supabase/usecase/check_verify_sms_time_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_up_or_in_use_case.dart';
import 'package:fortune/domain/supabase/usecase/verify_phone_number_use_case.dart';
import 'package:fortune/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'verify_code.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState>
    with SideEffectBlocMixin<VerifyCodeEvent, VerifyCodeState, VerifyCodeSideEffect> {
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final CheckVerifySmsTimeUseCase checkVerifySmsTimeUseCase;
  final SignUpOrInUseCase signUpOrInUseCase;
  final CancelWithdrawalUseCase cancelWithdrawalUseCase;

  static const tag = "[PhoneNumberBloc]";
  static const verifyTime = 180;

  VerifyCodeBloc({
    required this.verifyPhoneNumberUseCase,
    required this.checkVerifySmsTimeUseCase,
    required this.signUpOrInUseCase,
    required this.cancelWithdrawalUseCase,
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
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        countryInfoEntity: event.countryInfoEntity,
      ),
    );
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
    emit(state.copyWith(isLoginProcessing: true));

    await verifyPhoneNumberUseCase(
      RequestVerifyPhoneNumberParam(
        phoneNumber: state.phoneNumber,
        verifyCode: state.verifyCode,
      ),
    ).then(
      (value) => value.fold((l) {
        emit(state.copyWith(isLoginProcessing: false));
        produceSideEffect(VerifyCodeError(l));
      }, (r) async {
        // 탈퇴 처리 된 회원인 경우 철회 함.
        if (r.userEntity.isWithdrawal) {
          await cancelWithdrawalUseCase();
        }
        emit(state.copyWith(isLoginProcessing: false));
        produceSideEffect(VerifyCodeLandingRoute(Routes.mainRoute));
      }),
    );
  }

  _requestSignUpOrIn(Emitter<VerifyCodeState> emit) async {
    await checkVerifySmsTimeUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(VerifyCodeError(l)),
        (r) async {
          await signUpOrInUseCase(
            RequestSignUpParam(
              phoneNumber: state.phoneNumber,
              countryInfoId: state.countryInfoEntity.id,
            ),
          ).then(
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
