import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class MissionDetailSideEffect extends Equatable {}

class MissionDetailError extends MissionDetailSideEffect {
  final FortuneFailure error;

  MissionDetailError(this.error);

  @override
  List<Object?> get props => [];
}

class MissionDetailClearSuccess extends MissionDetailSideEffect {
  MissionDetailClearSuccess();

  @override
  List<Object?> get props => [];
}

class MissionDetailTest extends MissionDetailSideEffect {
  MissionDetailTest();

  @override
  List<Object?> get props => [];
}
