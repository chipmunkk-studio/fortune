import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RewardListEvent extends Equatable {}

class RewardListInit extends RewardListEvent {
  RewardListInit();

  @override
  List<Object?> get props => [];
}
