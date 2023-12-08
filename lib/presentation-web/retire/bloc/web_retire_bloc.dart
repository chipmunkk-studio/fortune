import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/domain/supabase/usecase/get_user_use_case.dart';
import 'package:fortune/domain/supabase/usecase/sign_in_with_email_use_case.dart';
import 'package:fortune/env.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'web_retire.dart';

class WebRetireBloc extends Bloc<WebRetireEvent, WebRetireState>
    with SideEffectBlocMixin<WebRetireEvent, WebRetireState, WebRetireSideEffect> {
  final GetUserUseCase getUserUseCase;
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final Environment env;

  WebRetireBloc({
    required this.getUserUseCase,
    required this.signInWithEmailUseCase,
    required this.env,
  }) : super(WebRetireState.initial()) {
    on<WebRetireInit>(init);
    on<WebRetireEmailInput>(
      emailInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<WebRetireBottomButtonClick>(clickNextButton);
    on<WebRetireRequestVerifyCode>(requestVerifyCode);
  }

  FutureOr<void> init(WebRetireInit event, Emitter<WebRetireState> emit) async {
    emit(state.copyWith(isLoading: false));
  }

  FutureOr<void> emailInput(WebRetireEmailInput event, Emitter<WebRetireState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        isButtonEnabled: FortuneValidator.isValidEmail(event.email),
      ),
    );
  }

  FutureOr<void> clickNextButton(WebRetireBottomButtonClick event, Emitter<WebRetireState> emit) async {
    await _processSignInOrUp(emit);
  }

  Future<void> _processSignInOrUp(Emitter<WebRetireState> emit) async {
    await getUserUseCase(
      state.email,
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(WebRetireError(l)),
        (r) async {
          // 회원 탈퇴 여부.
          if (r != null && r.isWithdrawal) {
            produceSideEffect(WebRetireWithdrawalUser());
            return;
          }
          // 사용자가 가입되어 있으면 인증번호 전송 로직을 처리
          if (r != null) {
            // 인증번호 전송
            produceSideEffect(WebRetireShowVerifyCodeBottomSheet(state.email));
          } else {
            // 존재하지 않는 사용자
            produceSideEffect(WebRetireNotExistUser());
          }
        },
      ),
    );
  }

  // 약관 동의 후 인증 번호 바텀시트 띄움.
  FutureOr<void> requestVerifyCode(WebRetireRequestVerifyCode event, Emitter<WebRetireState> emit) async {
    produceSideEffect(WebRetireShowVerifyCodeBottomSheet(state.email));
  }
}
