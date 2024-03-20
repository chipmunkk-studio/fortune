import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';

@immutable
abstract class RandomScratchSingleSideEffect extends Equatable {}

class RandomScratchSingleError extends RandomScratchSingleSideEffect {
  final FortuneFailureDeprecated error;

  RandomScratchSingleError(this.error);

  @override
  List<Object?> get props => [];
}

class RandomScratchSingleProgressEnd extends RandomScratchSingleSideEffect {
  final IngredientActionParam randomNormalSelected;

  RandomScratchSingleProgressEnd(this.randomNormalSelected);

  @override
  List<Object?> get props => [];
}
