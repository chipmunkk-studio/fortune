import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RewardDetailEvent extends Equatable {}

class RewardDetailInit extends RewardDetailEvent {
  RewardDetailInit(this.id);

  final int id;

  @override
  List<Object?> get props => [];
}

class RewardDetailExchange extends RewardDetailEvent {
  RewardDetailExchange();

  @override
  List<Object?> get props => [];
}
