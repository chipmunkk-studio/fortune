import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AlarmFeedEvent extends Equatable {}

class AlarmRewardInit extends AlarmFeedEvent {
  AlarmRewardInit();

  @override
  List<Object?> get props => [];
}
