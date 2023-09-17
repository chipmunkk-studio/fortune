import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class GradeGuideSideEffect extends Equatable {}

class GradeGuideError extends GradeGuideSideEffect {
  final FortuneFailure error;

  GradeGuideError(this.error);

  @override
  List<Object?> get props => [];
}