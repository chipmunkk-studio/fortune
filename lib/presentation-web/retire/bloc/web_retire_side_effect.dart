import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class WebRetireSideEffect extends Equatable {}

class WebRetireError extends WebRetireSideEffect {
  final FortuneFailure error;

  WebRetireError(this.error);

  @override
  List<Object?> get props => [];
}

class WebRetireShowTermsBottomSheet extends WebRetireSideEffect {
  final String phoneNumber;

  WebRetireShowTermsBottomSheet(
    this.phoneNumber,
  );

  @override
  List<Object?> get props => [];
}

class WebRetireShowVerifyCodeBottomSheet extends WebRetireSideEffect {
  final String email;

  WebRetireShowVerifyCodeBottomSheet(this.email);

  @override
  List<Object?> get props => [];
}

class WebRetireLandingRoute extends WebRetireSideEffect {
  final String route;

  WebRetireLandingRoute(this.route);

  @override
  List<Object?> get props => [route];
}

class WebRetireWithdrawalUser extends WebRetireSideEffect {
  WebRetireWithdrawalUser();

  @override
  List<Object?> get props => [];
}

class WebRetireNotExistUser extends WebRetireSideEffect {
  WebRetireNotExistUser();

  @override
  List<Object?> get props => [];
}
