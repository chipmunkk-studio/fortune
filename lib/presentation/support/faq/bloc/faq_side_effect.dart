import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class FaqSideEffect extends Equatable {}

class FaqError extends FaqSideEffect {
  final FortuneFailure error;

  FaqError(this.error);

  @override
  List<Object?> get props => [];
}