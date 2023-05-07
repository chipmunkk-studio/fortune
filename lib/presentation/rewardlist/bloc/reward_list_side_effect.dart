import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';


@immutable
abstract class RewardListSideEffect extends Equatable {}

class RewardListError extends RewardListSideEffect {
  final FortuneFailure error;

  RewardListError(this.error);

  @override
  List<Object?> get props => [];
}