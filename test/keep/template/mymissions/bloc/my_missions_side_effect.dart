import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class MyMissionsSideEffect extends Equatable {}

class MyMissionsError extends MyMissionsSideEffect {
  final FortuneFailureDeprecated error;

  MyMissionsError(this.error);

  @override
  List<Object?> get props => [];
}