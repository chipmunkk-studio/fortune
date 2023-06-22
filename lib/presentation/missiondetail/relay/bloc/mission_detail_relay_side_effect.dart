import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class MissionDetailRelaySideEffect extends Equatable {}

class MissionDetailRelayError extends MissionDetailRelaySideEffect {
  final FortuneFailure error;

  MissionDetailRelayError(this.error);

  @override
  List<Object?> get props => [];
}

class MissionClearSuccess extends MissionDetailRelaySideEffect {
  MissionClearSuccess();

  @override
  List<Object?> get props => [];
}
