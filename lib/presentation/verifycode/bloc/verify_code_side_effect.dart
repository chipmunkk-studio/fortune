import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/sms_verify_remain_time_entity.dart';

@immutable
abstract class VerifyCodeSideEffect extends Equatable {}

class VerifyCodeError extends VerifyCodeSideEffect {
  final FortuneFailure error;

  VerifyCodeError(this.error);

  @override
  List<Object?> get props => [];
}

class VerifyCodeLandingRoute extends VerifyCodeSideEffect {
  final String landingRoute;

  VerifyCodeLandingRoute(this.landingRoute);

  @override
  List<Object?> get props => [];
}

class VerifyCodeSmsListening extends VerifyCodeSideEffect {
  VerifyCodeSmsListening();

  @override
  List<Object?> get props => [];
}

class VerifyCodeInputFromSmsListening extends VerifyCodeSideEffect {
  final String code;

  VerifyCodeInputFromSmsListening(this.code);

  @override
  List<Object?> get props => [];
}