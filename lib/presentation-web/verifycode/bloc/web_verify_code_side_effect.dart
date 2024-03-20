import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/sms_verify_remain_time_entity.dart';

@immutable
abstract class WebVerifyCodeSideEffect extends Equatable {}

class WebVerifyCodeError extends WebVerifyCodeSideEffect {
  final FortuneFailureDeprecated error;

  WebVerifyCodeError(this.error);

  @override
  List<Object?> get props => [];
}

class WebVerifyCodeLandingRoute extends WebVerifyCodeSideEffect {
  final String landingRoute;

  WebVerifyCodeLandingRoute(this.landingRoute);

  @override
  List<Object?> get props => [];
}

class WebVerifyCodeRetireSuccess extends WebVerifyCodeSideEffect {

  WebVerifyCodeRetireSuccess();

  @override
  List<Object?> get props => [];
}