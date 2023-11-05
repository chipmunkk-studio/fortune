import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class FortuneWebviewSideEffect extends Equatable {}

class FortuneWebviewError extends FortuneWebviewSideEffect {
  final FortuneFailure error;

  FortuneWebviewError(this.error);

  @override
  List<Object?> get props => [];
}