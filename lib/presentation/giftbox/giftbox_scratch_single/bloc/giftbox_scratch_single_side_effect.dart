import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';

@immutable
abstract class GiftboxScratchSingleSideEffect extends Equatable {}

class GiftboxScratchSingleError extends GiftboxScratchSingleSideEffect {
  final FortuneFailureDeprecated error;

  GiftboxScratchSingleError(this.error);

  @override
  List<Object?> get props => [];
}

class GiftboxScratchSingleProgressEnd extends GiftboxScratchSingleSideEffect {
  final GiftboxActionParam randomNormalSelected;

  GiftboxScratchSingleProgressEnd(this.randomNormalSelected);

  @override
  List<Object?> get props => [];
}
