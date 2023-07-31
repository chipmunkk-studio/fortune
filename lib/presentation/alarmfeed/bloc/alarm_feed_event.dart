import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AlarmFeedEvent extends Equatable {}

class AlarmFeedInit extends AlarmFeedEvent {
  AlarmFeedInit();

  @override
  List<Object?> get props => [];
}
