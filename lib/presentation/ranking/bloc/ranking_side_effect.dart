import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class RankingSideEffect extends Equatable {}

class RankingError extends RankingSideEffect {
  final FortuneFailureDeprecated error;

  RankingError(this.error);

  @override
  List<Object?> get props => [];
}