import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';

@immutable
abstract class FortuneObtainSideEffect extends Equatable {}

class FortuneObtainError extends FortuneObtainSideEffect {
  final FortuneFailure error;

  FortuneObtainError(this.error);

  @override
  List<Object?> get props => [];
}

class FortuneCoinOrNormalObtainSuccess extends FortuneObtainSideEffect {
  final MarkerObtainEntity entity;

  FortuneCoinOrNormalObtainSuccess(this.entity);

  @override
  List<Object?> get props => [];
}