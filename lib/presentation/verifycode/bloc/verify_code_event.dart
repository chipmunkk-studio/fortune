import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VerifyCodeEvent extends Equatable {}

class VerifyCodeInit extends VerifyCodeEvent {
  final String phoneNumber;

  VerifyCodeInit(this.phoneNumber);

  @override
  List<Object?> get props => [];
}

class VerifyCodeCountdown extends VerifyCodeEvent {
  @override
  List<Object?> get props => [];
}

class VerifyCodeInput extends VerifyCodeEvent {
  final String verifyCode;

  VerifyCodeInput({
    required this.verifyCode,
  });

  @override
  List<Object?> get props => [];
}

class VerifyConfirm extends VerifyCodeEvent {
  VerifyConfirm();

  @override
  List<Object?> get props => [];
}

class VerifyCodeRequestVerifyCode extends VerifyCodeEvent {
  VerifyCodeRequestVerifyCode();

  @override
  List<Object?> get props => [];
}
