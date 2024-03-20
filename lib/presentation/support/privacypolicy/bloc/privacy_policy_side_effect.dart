import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class PrivacyPolicySideEffect extends Equatable {}

class PrivacyPolicyError extends PrivacyPolicySideEffect {
  final FortuneFailureDeprecated error;

  PrivacyPolicyError(this.error);

  @override
  List<Object?> get props => [];
}