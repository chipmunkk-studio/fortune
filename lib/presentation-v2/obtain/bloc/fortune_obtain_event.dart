import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/presentation-v2/obtain/fortune_obtain_param.dart';

@immutable
abstract class FortuneObtainEvent extends Equatable {}

class FortuneObtainInit extends FortuneObtainEvent {
  final FortuneObtainParam param;

  FortuneObtainInit(this.param);

  @override
  List<Object?> get props => [];
}