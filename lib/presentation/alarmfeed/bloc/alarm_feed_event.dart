import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';

@immutable
abstract class AlarmFeedEvent extends Equatable {}

class AlarmRewardInit extends AlarmFeedEvent {
  AlarmRewardInit();

  @override
  List<Object?> get props => [];
}


class AlarmRewardReceive extends AlarmFeedEvent {
  final AlarmFeedsEntity entity;

  AlarmRewardReceive(this.entity);

  @override
  List<Object?> get props => [];
}
