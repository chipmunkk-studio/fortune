import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';

@immutable
abstract class MissionDetailSideEffect extends Equatable {}

class MissionDetailError extends MissionDetailSideEffect {
  final FortuneFailure error;

  MissionDetailError(this.error);

  @override
  List<Object?> get props => [];
}

class MissionDetailParticleBurst extends MissionDetailSideEffect {
  MissionDetailParticleBurst();

  @override
  List<Object?> get props => [];
}

class MissionDetailAcquireSuccess extends MissionDetailSideEffect {
  final FortuneUserEntity user;

  MissionDetailAcquireSuccess(this.user);

  @override
  List<Object?> get props => [];
}
