import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class AlarmFeedSideEffect extends Equatable {}

class AlarmFeedError extends AlarmFeedSideEffect {
  final FortuneFailure error;

  AlarmFeedError(this.error);

  @override
  List<Object?> get props => [];
}