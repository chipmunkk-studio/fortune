import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/fortune_app_failures.dart';

@immutable
abstract class FortuneHistorySideEffect extends Equatable {}

class FortuneHistoryError extends FortuneHistorySideEffect {
  final FortuneFailure error;

  FortuneHistoryError(this.error);

  @override
  List<Object?> get props => [];
}