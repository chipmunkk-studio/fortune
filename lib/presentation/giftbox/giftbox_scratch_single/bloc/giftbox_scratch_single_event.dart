import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';

@immutable
abstract class GiftboxScratchSingleEvent extends Equatable {}

class GiftboxScratchSingleEnd extends GiftboxScratchSingleEvent {
  GiftboxScratchSingleEnd();

  @override
  List<Object?> get props => [];
}

class GiftboxScratchSingleProgress extends GiftboxScratchSingleEvent {
  final double progress;

  GiftboxScratchSingleProgress({
    required this.progress,
  });

  @override
  List<Object?> get props => [progress];
}

class GiftboxScratchSingleInit extends GiftboxScratchSingleEvent {
  final GiftboxActionParam randomNormalSelected;
  final List<IngredientEntity> randomNormalIngredients;

  GiftboxScratchSingleInit({
    required this.randomNormalSelected,
    required this.randomNormalIngredients,
  });

  @override
  List<Object?> get props => [];
}
