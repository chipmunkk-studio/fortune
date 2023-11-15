import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';

@immutable
abstract class IngredientActionSideEffect extends Equatable {}

class IngredientActionError extends IngredientActionSideEffect {
  final FortuneFailure error;

  IngredientActionError(this.error);

  @override
  List<Object?> get props => [];
}

class IngredientProcessAction extends IngredientActionSideEffect {
  final IngredientActionParam param;

  IngredientProcessAction(this.param);

  @override
  List<Object?> get props => [];
}

class IngredientAdShowComplete extends IngredientActionSideEffect {
  final IngredientEntity ingredient;
  final bool result;

  IngredientAdShowComplete({
    required this.ingredient,
    required this.result,
  });

  @override
  List<Object?> get props => [];
}
