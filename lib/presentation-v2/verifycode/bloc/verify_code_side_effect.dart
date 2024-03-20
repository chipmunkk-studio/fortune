import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/data/error/fortune_error.dart';

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
