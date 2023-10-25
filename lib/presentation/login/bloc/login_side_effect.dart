import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/presentation/login/bloc/login_state.dart';

@immutable
abstract class LoginSideEffect extends Equatable {}

class LoginError extends LoginSideEffect {
  final FortuneFailure error;

  LoginError(this.error);

  @override
  List<Object?> get props => [];
}

class LoginShowTermsBottomSheet extends LoginSideEffect {
  final String phoneNumber;

  LoginShowTermsBottomSheet(
    this.phoneNumber,
  );

  @override
  List<Object?> get props => [];
}

class LoginShowVerifyCodeBottomSheet extends LoginSideEffect {
  final String email;

  LoginShowVerifyCodeBottomSheet(
    this.email,
  );

  @override
  List<Object?> get props => [];
}

class LoginLandingRoute extends LoginSideEffect {
  final String route;

  LoginLandingRoute(this.route);

  @override
  List<Object?> get props => [route];
}

class LoginWithdrawalUser extends LoginSideEffect {
  LoginWithdrawalUser();

  @override
  List<Object?> get props => [];
}
