import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';

@immutable
abstract class AlarmFeedSideEffect extends Equatable {}

class AlarmFeedError extends AlarmFeedSideEffect {
  final FortuneFailure error;

  AlarmFeedError(this.error);

  @override
  List<Object?> get props => [];
}

class AlarmFeedReceiveConfetti extends AlarmFeedSideEffect {

  AlarmFeedReceiveConfetti();

  @override
  List<Object?> get props => [];
}

class AlarmFeedReceiveShowDialog extends AlarmFeedSideEffect {
  final AlarmFeedsEntity entity;

  AlarmFeedReceiveShowDialog(this.entity);

  @override
  List<Object?> get props => [];
}