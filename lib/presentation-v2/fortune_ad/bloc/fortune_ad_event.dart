import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/presentation-v2/fortune_ad/fortune_ad_param.dart';

@immutable
abstract class FortuneAdEvent extends Equatable {}

class FortuneAdInit extends FortuneAdEvent {
  final FortuneAdParam param;

  FortuneAdInit(this.param);

  @override
  List<Object?> get props => [];
}

class FortuneAdShowComplete extends FortuneAdEvent {
  FortuneAdShowComplete();

  @override
  List<Object?> get props => [];
}
