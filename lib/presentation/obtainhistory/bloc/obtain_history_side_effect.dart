import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/fortune_app_failures.dart';

@immutable
abstract class ObtainHistorySideEffect extends Equatable {}

class ObtainHistoryError extends ObtainHistorySideEffect {
  final FortuneFailure error;

  ObtainHistoryError(this.error);

  @override
  List<Object?> get props => [];
}

class ObtainHistoryInitSearchText extends ObtainHistorySideEffect {
  final String text;

  ObtainHistoryInitSearchText(this.text);

  @override
  List<Object?> get props => [];
}