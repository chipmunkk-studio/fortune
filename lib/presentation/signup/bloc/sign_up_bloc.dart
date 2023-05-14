import 'dart:async';
import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/notification/notification_manager.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:single_item_storage/storage.dart';

import '../../../core/network/credential/token_response.dart';
import '../../../core/network/credential/user_credential.dart';
import '../../../core/util/logger.dart';
import '../../../domain/usecases/check_nickname_usecase.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import 'sign_up.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState>
    with SideEffectBlocMixin<SignUpEvent, SignUpState, SignUpSideEffect> {
  static const tag = "[SignUpBloc]";

  final CheckNicknameUseCase checkNicknameUseCase;
  final SignUpUseCase signUpUseCase;
  final Storage<UserCredential> userStorage;
  final FortuneNotificationsManager fcmManager;

  SignUpBloc({
    required this.checkNicknameUseCase,
    required this.signUpUseCase,
    required this.userStorage,
    required this.fcmManager,
  }) : super(SignUpState.initial()) {
    on<SignUpInit>(init);
    on<SignUpNickNameInput>(nicknameInput);
    on<SignUpCheckNickname>(checkNickname);
    on<SignUpProfileChange>(profileChange);
    on<SignUpRequestStorageAuth>(showRequestStorageAuthDialog);
    on<SignUpRequest>(signUpRequest);
    on<SignUpNicknameClear>(nicknameClear);
  }

  FutureOr<void> init(SignUpInit event, Emitter<SignUpState> emit) async {
    final String? countryCode = event.countryCode;
    final String? phoneNumber = event.phoneNumber;
    if (countryCode != null && phoneNumber != null) {
      emit(
        state.copyWith(
          signUpForm: state.signUpForm.copyWith(
            countryCode: countryCode,
            phoneNumber: phoneNumber,
          ),
        ),
      );
    }
  }

  // 닉네임 입력.
  FutureOr<void> nicknameInput(SignUpNickNameInput event, Emitter<SignUpState> emit) {
    FortuneLogger.debug("$state");
    emit(
      state.copyWith(
        signUpForm: state.signUpForm.copyWith(
          nickname: event.nickname,
        ),
      ),
    );
  }

  // 닉네임 유효성 검사.
  FutureOr<void> checkNickname(SignUpCheckNickname event, Emitter<SignUpState> emit) async {
    checkNicknameUseCase(
      RequestCheckNickNameParams(
        nickname: state.signUpForm.nickname,
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(SignUpNickNameError(l)),
        (r) => produceSideEffect(SignUpMoveNext(SignUpMoveNextPage.profile)),
      ),
    );
  }

  // 프로필 이미지 변경.
  FutureOr<void> profileChange(SignUpProfileChange event, Emitter<SignUpState> emit) {
    emit(state.copyWith(profileImage: event.profileImage));
  }

  // 갤러리 권한 요청 화면 보여주기.
  FutureOr<void> showRequestStorageAuthDialog(SignUpRequestStorageAuth event, Emitter<SignUpState> emit) {
    produceSideEffect(SignUpShowRequestStorageAuthDialog());
  }

  // 회원가입.
  FutureOr<void> signUpRequest(SignUpRequest event, Emitter<SignUpState> emit) async {
    // 푸시토큰 가져와야됨.
    signUpUseCase(RequestSignUpParams(
      data: state.signUpForm,
      profileImage: state.profileImage,
      pushToken: await fcmManager.getFcmPushToken(),
    )).then(
      (value) => value.fold(
        (l) => produceSideEffect(SignUpProfileError(l)),
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
          AppMetrica.reportEventWithJson('회원가입완료', jsonEncode(state.signUpForm.toJson()));
          FortuneLogger.debug("회원가입완료: $saveCredential");
          produceSideEffect(SignUpMoveNext(SignUpMoveNextPage.complete));
        },
      ),
    );
  }

  // 닉네임 삭제.
  FutureOr<void> nicknameClear(SignUpNicknameClear event, Emitter<SignUpState> emit) {
    emit(state.copyWith(signUpForm: state.signUpForm.copyWith(nickname: "")));
  }
}
