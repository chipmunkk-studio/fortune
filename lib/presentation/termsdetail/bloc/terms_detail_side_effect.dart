import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class TermsDetailSideEffect extends Equatable {}

class TermsDetailError extends TermsDetailSideEffect {
  final FortuneFailure error;

  TermsDetailError(this.error);

  @override
  List<Object?> get props => [];
}