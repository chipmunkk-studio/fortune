import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MissionDetailEvent extends Equatable {}

class MissionDetailInit extends MissionDetailEvent {
  MissionDetailInit(this.id);

  final int id;

  @override
  List<Object?> get props => [];
}

class MissionDetailExchange extends MissionDetailEvent {
  MissionDetailExchange();

  @override
  List<Object?> get props => [];
}
