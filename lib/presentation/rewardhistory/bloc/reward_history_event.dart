import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RewardHistoryEvent extends Equatable {}

class RewardHistoryInit extends RewardHistoryEvent {
  RewardHistoryInit();

  @override
  List<Object?> get props => [];
}

class RewardHistoryNextPage extends RewardHistoryEvent {
  RewardHistoryNextPage();

  @override
  List<Object?> get props => [];
}

