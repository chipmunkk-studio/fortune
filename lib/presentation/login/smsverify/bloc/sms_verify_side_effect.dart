import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class SmsVerifySideEffect extends Equatable {}

class SmsVerifyError extends SmsVerifySideEffect {
  final FortuneFailure error;

  SmsVerifyError(this.error);

  @override
  List<Object?> get props => [];
}

class SmsVerifyMovePage extends SmsVerifySideEffect {
  final SmsVerifyNextPage page;

  SmsVerifyMovePage(this.page);

  @override
  List<Object?> get props => [];
}

class SmsVerifyOpenSetting extends SmsVerifySideEffect {
  SmsVerifyOpenSetting();

  @override
  List<Object?> get props => [];
}

class SmsVerifyStartListening extends SmsVerifySideEffect {
  SmsVerifyStartListening();

  @override
  List<Object?> get props => [];
}

/// 다음페이지
/// - 회원가입 일 경우에는 nickName.
/// - 기존 회원 일 경우에는 navigation
enum SmsVerifyNextPage {
  nickName,
  navigation,
}
