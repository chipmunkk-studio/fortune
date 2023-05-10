import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/fortune_app_failures.dart';

@immutable
abstract class MarkerHistorySideEffect extends Equatable {}

class MarkerHistoryError extends MarkerHistorySideEffect {
  final FortuneFailure error;

  MarkerHistoryError(this.error);

  @override
  List<Object?> get props => [];
}