import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_entity.dart';

@immutable
abstract class MissionDetailNormalEvent extends Equatable {}

class MissionDetailNormalInit extends MissionDetailNormalEvent {
  MissionDetailNormalInit(this.mission);

  final MissionNormalEntity mission;

  @override
  List<Object?> get props => [];
}

class MissionDetailNormalExchange extends MissionDetailNormalEvent {
  MissionDetailNormalExchange();

  @override
  List<Object?> get props => [];
}
