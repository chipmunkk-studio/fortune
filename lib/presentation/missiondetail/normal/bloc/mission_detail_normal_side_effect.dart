import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class MissionDetailNormalSideEffect extends Equatable {}

class MissionDetailNormalError extends MissionDetailNormalSideEffect {
  final FortuneFailure error;

  MissionDetailNormalError(this.error);

  @override
  List<Object?> get props => [];
}

class MissionDetailNormalClearSuccess extends MissionDetailNormalSideEffect {
  MissionDetailNormalClearSuccess();

  @override
  List<Object?> get props => [];
}
