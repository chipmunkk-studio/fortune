import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class AgreeTermsSideEffect extends Equatable {}

class AgreeTermsError extends AgreeTermsSideEffect {
  final FortuneFailure error;

  AgreeTermsError(this.error);

  @override
  List<Object?> get props => [];
}

class AgreeTermsPop extends AgreeTermsSideEffect {
  final bool flag;

  AgreeTermsPop(this.flag);

  @override
  List<Object?> get props => [];
}
