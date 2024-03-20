import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';

@immutable
abstract class GiftboxActionSideEffect extends Equatable {}

class GiftboxActionError extends GiftboxActionSideEffect {
  final FortuneFailureDeprecated error;

  GiftboxActionError(this.error);

  @override
  List<Object?> get props => [];
}

class GiftboxProcessObtainAction extends GiftboxActionSideEffect {
  final IngredientEntity ingredient;

  GiftboxProcessObtainAction({
    required this.ingredient,
  });

  @override
  List<Object?> get props => [];
}
