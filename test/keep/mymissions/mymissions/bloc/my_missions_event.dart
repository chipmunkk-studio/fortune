import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MyMissionsEvent extends Equatable {}

class MyMissionsInit extends MyMissionsEvent {
  MyMissionsInit();

  @override
  List<Object?> get props => [];
}
