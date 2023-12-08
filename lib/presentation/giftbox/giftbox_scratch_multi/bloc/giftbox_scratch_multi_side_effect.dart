import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';

@immutable
abstract class GiftboxScratchMultiSideEffect extends Equatable {}

class GiftboxScratchMultiError extends GiftboxScratchMultiSideEffect {
  final FortuneFailure error;

  GiftboxScratchMultiError(this.error);

  @override
  List<Object?> get props => [];
}

class GiftboxScratchMultiProgressEnd extends GiftboxScratchMultiSideEffect {
  final GiftboxActionParam randomNormalSelected;

  GiftboxScratchMultiProgressEnd(this.randomNormalSelected);

  @override
  List<Object?> get props => [];
}
