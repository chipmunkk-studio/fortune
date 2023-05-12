import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class RewardDetailSideEffect extends Equatable {}

class RewardDetailInventoryError extends RewardDetailSideEffect {
  final FortuneFailure error;

  RewardDetailInventoryError(this.error);

  @override
  List<Object?> get props => [];
}

class RewardDetailExchangeSuccess extends RewardDetailSideEffect {
  RewardDetailExchangeSuccess();

  @override
  List<Object?> get props => [];
}
