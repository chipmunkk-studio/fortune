import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';

@immutable
abstract class GiftboxActionEvent extends Equatable {}

class GiftboxActionInit extends GiftboxActionEvent {
  final GiftboxActionParam param;

  GiftboxActionInit(this.param);

  @override
  List<Object?> get props => [];
}

class GiftboxActionShowAdCounting extends GiftboxActionEvent {
  GiftboxActionShowAdCounting();

  @override
  List<Object?> get props => [];
}

class GiftboxActionObtainSuccess extends GiftboxActionEvent {
  final IngredientEntity entity;

  GiftboxActionObtainSuccess(this.entity);

  @override
  List<Object?> get props => [];
}
