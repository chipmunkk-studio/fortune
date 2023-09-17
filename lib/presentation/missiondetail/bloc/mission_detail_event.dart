import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_view_entity.dart';

import '../../missions/bloc/missions.dart';

@immutable
abstract class MissionDetailEvent extends Equatable {}

class MissionDetailInit extends MissionDetailEvent {
  MissionDetailInit(this.mission);

  final MissionViewEntity mission;

  @override
  List<Object?> get props => [];
}

class MissionDetailExchange extends MissionDetailEvent {
  MissionDetailExchange();

  @override
  List<Object?> get props => [];
}
