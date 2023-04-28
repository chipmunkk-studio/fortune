import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MarkerHistoryEvent extends Equatable {}

class MarkerHistoryInit extends MarkerHistoryEvent {
  MarkerHistoryInit();

  @override
  List<Object?> get props => [];
}

class MarkerHistoryNextPage extends MarkerHistoryEvent {
  MarkerHistoryNextPage();

  @override
  List<Object?> get props => [];
}

