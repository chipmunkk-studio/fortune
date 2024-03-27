import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MissionsEvent extends Equatable {}

class MissionsInit extends MissionsEvent {
  MissionsInit();

  @override
  List<Object?> get props => [];
}
