import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VerifyCodeEvent extends Equatable {}

class VerifyCodeInit extends VerifyCodeEvent {
  VerifyCodeInit();

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
