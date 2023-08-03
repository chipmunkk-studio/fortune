import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class AlarmRewardSideEffect extends Equatable {}

class AlarmRewardError extends AlarmRewardSideEffect {
  final FortuneFailure error;

  AlarmRewardError(this.error);

  @override
  List<Object?> get props => [];
}