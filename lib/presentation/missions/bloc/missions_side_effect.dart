import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/error/fortune_error.dart';

@immutable
abstract class MissionsSideEffect extends Equatable {}

class MissionsError extends MissionsSideEffect {
  final FortuneFailureDeprecated error;

  MissionsError(this.error);

  @override
  List<Object?> get props => [];
}
