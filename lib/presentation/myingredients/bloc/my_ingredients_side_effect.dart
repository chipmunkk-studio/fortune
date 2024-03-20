import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class MyIngredientsSideEffect extends Equatable {}

class MyIngredientsError extends MyIngredientsSideEffect {
  final FortuneFailureDeprecated error;

  MyIngredientsError(this.error);

  @override
  List<Object?> get props => [];
}