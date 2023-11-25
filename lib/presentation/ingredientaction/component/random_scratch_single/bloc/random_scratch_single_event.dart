import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';

@immutable
abstract class RandomScratchSingleEvent extends Equatable {}

class RandomScratchSingleEnd extends RandomScratchSingleEvent {
  RandomScratchSingleEnd();

  @override
  List<Object?> get props => [];
}

class RandomScratchSingleProgress extends RandomScratchSingleEvent {
  final double progress;

  RandomScratchSingleProgress({
    required this.progress,
  });

  @override
  List<Object?> get props => [progress];
}

class RandomScratchSingleInit extends RandomScratchSingleEvent {
  final IngredientActionParam randomNormalSelected;
  final List<IngredientEntity> randomNormalIngredients;

  RandomScratchSingleInit({
    required this.randomNormalSelected,
    required this.randomNormalIngredients,
  });

  @override
  List<Object?> get props => [];
}
