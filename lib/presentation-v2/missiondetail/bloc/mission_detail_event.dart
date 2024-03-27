import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/presentation-v2/missiondetail/mission_detail_param.dart';

@immutable
abstract class MissionDetailEvent extends Equatable {}

class MissionDetailInit extends MissionDetailEvent {
  MissionDetailInit(this.param);

  final MissionDetailParam param;

  @override
  List<Object?> get props => [];
}

class MissionDetailExchange extends MissionDetailEvent {
  MissionDetailExchange();

  @override
  List<Object?> get props => [];
}
