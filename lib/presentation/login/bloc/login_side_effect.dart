import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';

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
  final String convertedPhoneNumber;
  final CountryInfoEntity countryInfoEntity;

  LoginShowVerifyCodeBottomSheet(
    this.convertedPhoneNumber,
    this.countryInfoEntity,
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
  bool isReSignIn;

  LoginWithdrawalUser(this.isReSignIn);

  @override
  List<Object?> get props => [];
}
