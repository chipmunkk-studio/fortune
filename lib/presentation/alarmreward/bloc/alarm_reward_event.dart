import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AlarmRewardEvent extends Equatable {}

class AlarmRewardInit extends AlarmRewardEvent {
  final int rewardId;

  AlarmRewardInit(this.rewardId);

  @override
  List<Object?> get props => [];
}
