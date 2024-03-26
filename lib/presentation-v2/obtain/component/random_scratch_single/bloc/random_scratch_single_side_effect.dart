import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/picked_item_entity.dart';

@immutable
abstract class RandomScratchSingleSideEffect extends Equatable {}

class RandomScratchSingleError extends RandomScratchSingleSideEffect {
  final FortuneFailure error;

  RandomScratchSingleError(this.error);

  @override
  List<Object?> get props => [];
}

class RandomScratchSingleProgressEnd extends RandomScratchSingleSideEffect {
  final PickedItemEntity pickedItemEntity;

  RandomScratchSingleProgressEnd(this.pickedItemEntity);

  @override
  List<Object?> get props => [];
}
