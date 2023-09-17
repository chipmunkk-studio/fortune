import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class FaqsSideEffect extends Equatable {}

class FaqError extends FaqsSideEffect {
  final FortuneFailure error;

  FaqError(this.error);

  @override
  List<Object?> get props => [];
}