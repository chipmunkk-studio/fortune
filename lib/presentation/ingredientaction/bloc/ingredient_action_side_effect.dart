import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_page.dart';

@immutable
abstract class IngredientActionSideEffect extends Equatable {}

class IngredientActionError extends IngredientActionSideEffect {
  final FortuneFailure error;

  IngredientActionError(this.error);

  @override
  List<Object?> get props => [];
}

class IngredientProcesAction extends IngredientActionSideEffect {
  final IngredientActionParam param;

  IngredientProcesAction(this.param);

  @override
  List<Object?> get props => [];
}

