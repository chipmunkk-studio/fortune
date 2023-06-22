import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';

@immutable
abstract class MissionDetailRelayEvent extends Equatable {}

class MissionDetailRelayInit extends MissionDetailRelayEvent {
  MissionDetailRelayInit(this.mission);

  final MissionEntity mission;

  @override
  List<Object?> get props => [];
}

class MissionDetailRelayExchange extends MissionDetailRelayEvent {
  MissionDetailRelayExchange();

  @override
  List<Object?> get props => [];
}
