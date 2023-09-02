import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';

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

  LoginShowVerifyCodeBottomSheet(this.convertedPhoneNumber);

  @override
  List<Object?> get props => [];
}

class LoginLandingRoute extends LoginSideEffect {
  final String route;

  LoginLandingRoute(this.route);

  @override
  List<Object?> get props => [route];
}
