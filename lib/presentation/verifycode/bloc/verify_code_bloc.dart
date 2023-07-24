import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_terms_use_case.dart';
import 'package:foresh_flutter/domain/supabase/usecase/verify_phone_number_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'verify_code.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState>
    with SideEffectBlocMixin<VerifyCodeEvent, VerifyCodeState, VerifyCodeSideEffect> {
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;

  static const tag = "[PhoneNumberBloc]";

  VerifyCodeBloc({
    required this.verifyPhoneNumberUseCase,
  }) : super(VerifyCodeState.initial()) {
    on<VerifyCodeInit>(init);
    on<VerifyCodeInput>(
      verifyCodeInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
  }

  FutureOr<void> init(VerifyCodeInit event, Emitter<VerifyCodeState> emit) async {}

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
        isRequestVerifyCodeEnable: FortuneValidator.isValidVerifyCode(event.verifyCode),
      ),
    );
  }

// await verifyPhoneNumberUseCase(
//   RequestVerifyPhoneNumberParam(
//     phoneNumber: _getConvertedPhoneNumber(state.phoneNumber),
//     verifyCode: state.verifyCode,
//   ),
// ).then(
//   (value) => value.fold(
//     (l) => produceSideEffect(LoginError(l)),
//     (r) => produceSideEffect(LoginLandingRoute(Routes.mainRoute)),
//   ),
// );
}
