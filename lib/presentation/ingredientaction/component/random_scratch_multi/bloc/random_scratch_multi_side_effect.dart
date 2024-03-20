import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';

@immutable
abstract class RandomScratchMultiSideEffect extends Equatable {}

class RandomScratchMultiError extends RandomScratchMultiSideEffect {
  final FortuneFailureDeprecated error;

  RandomScratchMultiError(this.error);

  @override
  List<Object?> get props => [];
}

class RandomScratchMultiProgressEnd extends RandomScratchMultiSideEffect {
  final IngredientActionParam randomNormalSelected;

  RandomScratchMultiProgressEnd(this.randomNormalSelected);

  @override
  List<Object?> get props => [];
}
