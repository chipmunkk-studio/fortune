import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/presentation-v2/fortune_ad/admanager/fortune_ad.dart';

@immutable
abstract class FortuneAdSideEffect extends Equatable {}

class FortuneAdError extends FortuneAdSideEffect {
  final FortuneFailure error;

  FortuneAdError(this.error);

  @override
  List<Object?> get props => [];
}

class FortuneShowAdmob extends FortuneAdSideEffect {
  final FortuneAdmobAdStateEntity ad;

  FortuneShowAdmob(this.ad);

  @override
  List<Object?> get props => [];
}

class FortuneAdShowCompleteReturn extends FortuneAdSideEffect {
  final FortuneUserEntity user;

  FortuneAdShowCompleteReturn(this.user);

  @override
  List<Object?> get props => [];
}
