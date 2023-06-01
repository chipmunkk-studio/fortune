import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/domain/entities/agree_terms_entity.dart';

@immutable
abstract class LoginSideEffect extends Equatable {}

class LoginError extends LoginSideEffect {
  final FortuneFailure error;

  LoginError(this.error);

  @override
  List<Object?> get props => [];
}

class LoginLandingRoute extends LoginSideEffect {
  final String landingRoute;

  LoginLandingRoute(this.landingRoute);

  @override
  List<Object?> get props => [];
}

class LoginShowTermsBottomSheet extends LoginSideEffect {
  final List<AgreeTermsEntity> terms;
  final String phoneNumber;

  LoginShowTermsBottomSheet({
    required this.terms,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [];
}

class LoginNextStep extends LoginSideEffect {
  LoginNextStep();

  @override
  List<Object?> get props => [];
}

class LoginShowSnackBar extends LoginSideEffect {
  final String text;

  LoginShowSnackBar(this.text);

  @override
  List<Object?> get props => [];
}
