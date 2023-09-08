import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MyIngredientsEvent extends Equatable {}

class MyIngredientsInit extends MyIngredientsEvent {
  MyIngredientsInit();

  @override
  List<Object?> get props => [];
}
