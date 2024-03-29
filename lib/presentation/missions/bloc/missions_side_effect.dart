import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';


@immutable
abstract class MissionsSideEffect extends Equatable {}

class MissionsError extends MissionsSideEffect {
  final FortuneFailureDeprecated error;

  MissionsError(this.error);

  @override
  List<Object?> get props => [];
}