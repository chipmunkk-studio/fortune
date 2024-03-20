import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class TermsDetailSideEffect extends Equatable {}

class TermsDetailError extends TermsDetailSideEffect {
  final FortuneFailureDeprecated error;

  TermsDetailError(this.error);

  @override
  List<Object?> get props => [];
}
