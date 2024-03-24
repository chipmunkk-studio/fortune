import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/validators.dart';
import 'package:fortune/data/remote/network/credential/token_response.dart';
import 'package:fortune/data/remote/network/credential/user_credential.dart';
import 'package:fortune/domain/usecase/register_user_use_case.dart';
import 'package:fortune/domain/usecase/verify_email_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:single_item_storage/storage.dart';

import 'verify_code.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState>
    with SideEffectBlocMixin<VerifyCodeEvent, VerifyCodeState, VerifyCodeSideEffect> {
  final VerifyEmailUseCase verifyEmailUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final Storage<UserCredential> userStorage;

  VerifyCodeBloc({
    required this.verifyEmailUseCase,
    required this.registerUserUseCase,
    required this.userStorage,
  }) : super(VerifyCodeState.initial()) {
    on<VerifyCodeInit>(init);
    on<VerifyCodeCountdown>(verifyCodeCountdown);
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
        email: event.email,
        isRequestVerifyCodeEnable: false,
        verifyTime: 180,
      ),
    );
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
  }

  FutureOr<void> verifyConfirm(VerifyConfirm event, Emitter<VerifyCodeState> emit) async {
    emit(state.copyWith(isLoginProcessing: true));

    await verifyEmailUseCase(
      state.email,
      state.verifyCode,
    ).then(
      (value) => value.fold(
        (l) {
          emit(state.copyWith(isLoginProcessing: false));
          produceSideEffect(VerifyCodeError(l));
        },
        (r) async {
          emit(state.copyWith(isLoginProcessing: false));
          UserCredential credential = await userStorage.get() ?? UserCredential.initial();
          final signUpToken = r.signUpToken;

          /// 기존 회원 일 경우.
          if (signUpToken.isEmpty) {
            final user = await userStorage.save(
              credential.copy(
                token: TokenResponse(
                  accessToken: r.accessToken,
                  refreshToken: r.refreshToken,
                ),
              ),
            );
            FortuneLogger.info("#1 [Save Success]:: ${user.token.toString()}");
            produceSideEffect(VerifyCodeLandingRoute(AppRoutes.mainRoute));
          } else {
            /// 회원가입 일 경우.
            registerUserUseCase(signUpToken, null).then(
              (value) => value.fold(
                (l) => produceSideEffect(VerifyCodeError(l)),
                (signUpEntity) async {
                  final user = await userStorage.save(
                    credential.copy(
                      token: TokenResponse(
                        accessToken: signUpEntity.accessToken,
                        refreshToken: signUpEntity.refreshToken,
                      ),
                    ),
                  );
                  FortuneLogger.info("#2 [Save Success]:: ${user.token.toString()}");
                  produceSideEffect(VerifyCodeLandingRoute(AppRoutes.mainRoute));
                },
              ),
            );
          }
        },
      ),
    );
  }
}
