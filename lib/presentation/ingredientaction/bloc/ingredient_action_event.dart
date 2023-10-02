import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_page.dart';

@immutable
abstract class IngredientActionEvent extends Equatable {}

class IngredientActionInit extends IngredientActionEvent {
  final IngredientActionParam param;

  IngredientActionInit(this.param);

  @override
  List<Object?> get props => [];
}

class IngredientActionShowAdCounting extends IngredientActionEvent {
  IngredientActionShowAdCounting();

  @override
  List<Object?> get props => [];
}
