import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class WebAgreeTermsSideEffect extends Equatable {}

class WebAgreeTermsError extends WebAgreeTermsSideEffect {
  final FortuneFailureDeprecated error;

  WebAgreeTermsError(this.error);

  @override
  List<Object?> get props => [];
}

class WebAgreeTermsPop extends WebAgreeTermsSideEffect {
  final bool flag;

  WebAgreeTermsPop(this.flag);

  @override
  List<Object?> get props => [];
}
