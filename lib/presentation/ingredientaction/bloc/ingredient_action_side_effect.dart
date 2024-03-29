import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';

@immutable
abstract class IngredientActionSideEffect extends Equatable {}

class IngredientActionError extends IngredientActionSideEffect {
  final FortuneFailureDeprecated error;

  IngredientActionError(this.error);

  @override
  List<Object?> get props => [];
}

class IngredientProcessShowAdAction extends IngredientActionSideEffect {
  final IngredientActionParam param;
  final bool adMobStatus;

  IngredientProcessShowAdAction(
    this.param,
    this.adMobStatus,
  );

  @override
  List<Object?> get props => [];
}

class IngredientProcessObtainAction extends IngredientActionSideEffect {
  final IngredientEntity ingredient;

  IngredientProcessObtainAction({
    required this.ingredient,
  });

  @override
  List<Object?> get props => [];
}
