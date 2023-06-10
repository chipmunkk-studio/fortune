import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/fortune_app_failures.dart';

@immutable
abstract class RewardHistorySideEffect extends Equatable {}

class MarkerHistoryError extends RewardHistorySideEffect {
  final FortuneFailure error;

  MarkerHistoryError(this.error);

  @override
  List<Object?> get props => [];
}