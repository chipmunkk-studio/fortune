import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';

@immutable
abstract class WebLoginSideEffect extends Equatable {}

class WebLoginError extends WebLoginSideEffect {
  final FortuneFailureDeprecated error;

  WebLoginError(this.error);

  @override
  List<Object?> get props => [];
}

class WebLoginShowTermsBottomSheet extends WebLoginSideEffect {
  final String phoneNumber;

  WebLoginShowTermsBottomSheet(
    this.phoneNumber,
  );

  @override
  List<Object?> get props => [];
}

class WebLoginShowVerifyCodeBottomSheet extends WebLoginSideEffect {
  final String email;

  WebLoginShowVerifyCodeBottomSheet(this.email);

  @override
  List<Object?> get props => [];
}

class WebLoginLandingRoute extends WebLoginSideEffect {
  final String route;

  WebLoginLandingRoute(this.route);

  @override
  List<Object?> get props => [route];
}

class WebLoginWithdrawalUser extends WebLoginSideEffect {

  WebLoginWithdrawalUser();

  @override
  List<Object?> get props => [];
}
