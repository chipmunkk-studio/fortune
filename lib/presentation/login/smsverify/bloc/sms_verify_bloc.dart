import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/core/util/validators.dart';
import 'package:foresh_flutter/domain/usecases/obtain_sms_verify_code.dart';
import 'package:foresh_flutter/notification_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:single_item_storage/storage.dart';

import '../../../../core/network/credential/token_response.dart';
import '../../../../core/network/credential/user_credential.dart';
import '../../../../core/util/logger.dart';
import '../../../../domain/usecases/sms_verify_code_confirm_usecase.dart';
import 'sms_verify.dart';

class SmsVerifyBloc extends Bloc<SmsVerifyEvent, SmsVerifyState>
    with SideEffectBlocMixin<SmsVerifyEvent, SmsVerifyState, SmsVerifySideEffect> {
  static const tag = "[SmsVerifyBloc]";

  final ObtainSmsVerifyCodeUseCase obtainSmsVerifyCodeUseCase;
  final SmsVerifyCodeConfirmUseCase smsVerifyCodeConfirmUseCase;
  final Storage<UserCredential> userStorage;
  final NotificationsManager fcmManager;

  SmsVerifyBloc({
    required this.obtainSmsVerifyCodeUseCase,
    required this.smsVerifyCodeConfirmUseCase,
    required this.userStorage,
    required this.fcmManager,
  }) : super(SmsVerifyState.initial()) {
    on<SmsVerifyInit>(init);
    on<SmsVerifyRequestCode>(requestCode);
    on<SmsVerifyInput>(input);
    on<SmsVerifyBottomButtonPressed>(bottomButtonPressed);
  }

  FutureOr<void> init(SmsVerifyInit event, Emitter<SmsVerifyState> emit) async {
    String phoneNumber = event.phoneNumber;
    String countryCode = event.countryCode;
    bool isPermissionGranted = await FortunePermissionUtil().requestPermission([Permission.sms]);

    // 폰번호와 countryCode가 정상적으로 입력이 되어야 함 .
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      ),
    );

    // SMS 권한이 있는지 확인.
    // - SMS 권한은 안드로이드에서만 확인 함.
    if (!isPermissionGranted && Platform.isAndroid) {
      produceSideEffect(SmsVerifyOpenSetting());
      return;
    }

    // SMS 코드 요청.
    add(SmsVerifyRequestCode());
  }

  FutureOr<void> input(SmsVerifyInput event, Emitter<SmsVerifyState> emit) {
    String verifyCode = event.verifyCode;
    if (verifyCode.isNotEmpty) {
      bool isValid = FortuneValidator.isValidVerifyCode(event.verifyCode);
      emit(
        state.copyWith(
          verifyCode: verifyCode,
          isEnabled: isValid,
        ),
      );
      if (event.auto && isValid) {
        add(SmsVerifyBottomButtonPressed());
      }
    }
  }

  FutureOr<void> bottomButtonPressed(SmsVerifyBottomButtonPressed event, Emitter<SmsVerifyState> emit) async {
    await smsVerifyCodeConfirmUseCase(
      RequestConfirmSmsVerifyCodeParams(
        phoneNumber: state.phoneNumber,
        countryCode: state.countryCode,
        authenticationNumber: int.parse(state.verifyCode),
        pushToken: await fcmManager.getFcmPushToken(),
      ),
    ).then(
      (value) => value.fold((l) {
        produceSideEffect(SmsVerifyError(l));
        // produceSideEffect(SmsVerifyMovePage(SmsVerifyNextPage.nickName));
      }, (r) async {
        if (r.registered) {
          UserCredential credential = await userStorage.get() ?? UserCredential.initial();
          var saveCredential = await userStorage.save(
            credential.copy(
              token: TokenResponse(
                accessToken: r.accessToken,
                refreshToken: r.refreshToken,
              ),
            ),
          );
          produceSideEffect(SmsVerifyMovePage(SmsVerifyNextPage.navigation));
        } else {
          produceSideEffect(SmsVerifyMovePage(SmsVerifyNextPage.nickName));
        }
      }),
    );
  }

  FutureOr<void> requestCode(SmsVerifyRequestCode event, Emitter<SmsVerifyState> emit) async {
    // 권한이 있을 경우 Listening을 시작함.
    produceSideEffect(SmsVerifyStartListening());
    // 폰번호와 국가코드가 정상적으로 입력이 된 경우에만 수행.
    await obtainSmsVerifyCodeUseCase(
      RequestSmsVerifyCodeParams(
        phoneNumber: state.phoneNumber,
        countryCode: state.countryCode,
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(SmsVerifyError(l)),
        (r) {
          FortuneLogger.debug("휴대폰번호 인증 요청 성공");
        },
      ),
    );
  }
}
