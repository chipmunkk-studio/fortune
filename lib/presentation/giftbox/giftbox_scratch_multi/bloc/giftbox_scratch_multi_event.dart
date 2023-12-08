import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';

@immutable
abstract class GiftboxScratchMultiEvent extends Equatable {}

class GiftboxScratchMultiInit extends GiftboxScratchMultiEvent {
  final GiftboxActionParam randomScratchSelected;
  final List<IngredientEntity> randomScratchIngredients;

  GiftboxScratchMultiInit({
    required this.randomScratchSelected,
    required this.randomScratchIngredients,
  });

  @override
  List<Object?> get props => [];
}

class GiftboxScratchMultiEnd extends GiftboxScratchMultiEvent {
  GiftboxScratchMultiEnd();

  @override
  List<Object?> get props => [];
}

class GiftboxScratchMultiShowReceive extends GiftboxScratchMultiEvent {
  final GiftboxActionParam randomNormalSelected;

  GiftboxScratchMultiShowReceive(this.randomNormalSelected);

  @override
  List<Object?> get props => [];
}
