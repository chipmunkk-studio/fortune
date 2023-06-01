import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class LoginInit extends LoginEvent {
  final String phoneNumber;

  LoginInit(this.phoneNumber);

  @override
  List<Object?> get props => [];
}

class LoginPhoneNumberInput extends LoginEvent {
  final String phoneNumber;

  LoginPhoneNumberInput(this.phoneNumber);

  @override
  List<Object?> get props => [];
}

class LoginVerifyCodeInput extends LoginEvent {
  final String verifyCode;

  LoginVerifyCodeInput({
    required this.verifyCode,
  });

  @override
  List<Object?> get props => [];
}

class LoginBottomButtonClick extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginRequestVerifyCode extends LoginEvent {
  final bool isTermsAgree;

  LoginRequestVerifyCode({this.isTermsAgree = false});

  @override
  List<Object?> get props => [];
}

class LoginRequestVerifyCodeCountdown extends LoginEvent {
  @override
  List<Object?> get props => [];
}
