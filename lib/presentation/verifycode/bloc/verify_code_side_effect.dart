import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class VerifyCodeSideEffect extends Equatable {}

class AgreeTermsError extends VerifyCodeSideEffect {
  final FortuneFailure error;

  AgreeTermsError(this.error);

  @override
  List<Object?> get props => [];
}

class AgreeTermsPop extends VerifyCodeSideEffect {
  final bool flag;

  AgreeTermsPop(this.flag);

  @override
  List<Object?> get props => [];
}
