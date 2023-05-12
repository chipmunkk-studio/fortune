import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FortuneHistoryEvent extends Equatable {}

class FortuneHistoryInit extends FortuneHistoryEvent {
  FortuneHistoryInit();

  @override
  List<Object?> get props => [];
}