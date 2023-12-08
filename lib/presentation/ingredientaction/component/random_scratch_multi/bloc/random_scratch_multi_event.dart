import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/component/random_scratch_multi/bloc/random_scratch_grid_item.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';

@immutable
abstract class RandomScratchMultiEvent extends Equatable {}

class RandomScratchMultiInit extends RandomScratchMultiEvent {
  final IngredientActionParam randomScratchSelected;
  final List<IngredientEntity> randomScratchIngredients;

  RandomScratchMultiInit({
    required this.randomScratchSelected,
    required this.randomScratchIngredients,
  });

  @override
  List<Object?> get props => [];
}

class RandomScratchMultiEnd extends RandomScratchMultiEvent {
  RandomScratchMultiEnd();

  @override
  List<Object?> get props => [];
}


class RandomScratchMultiShowReceive extends RandomScratchMultiEvent {
  final IngredientActionParam randomNormalSelected;

  RandomScratchMultiShowReceive(this.randomNormalSelected);

  @override
  List<Object?> get props => [];
}

