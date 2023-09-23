import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';

@immutable
abstract class NickNameSideEffect extends Equatable {}

class NickNameError extends NickNameSideEffect {
  final FortuneFailure error;

  NickNameError(this.error);

  @override
  List<Object?> get props => [];
}


class NickNameUserInfoInit extends NickNameSideEffect {
  final FortuneUserEntity user;

  NickNameUserInfoInit(this.user);

  @override
  List<Object?> get props => [];
}
