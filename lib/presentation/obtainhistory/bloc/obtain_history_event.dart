import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ObtainHistoryEvent extends Equatable {}

class ObtainHistoryInit extends ObtainHistoryEvent {
  final String searchText;

  ObtainHistoryInit(this.searchText);

  @override
  List<Object?> get props => [];
}

class ObtainHistoryNextPage extends ObtainHistoryEvent {
  ObtainHistoryNextPage();

  @override
  List<Object?> get props => [];
}

class ObtainHistorySearchText extends ObtainHistoryEvent {
  final String text;

  ObtainHistorySearchText(this.text);

  @override
  List<Object?> get props => [];
}

class ObtainHistorySearchHistory extends ObtainHistoryEvent {
  final String text;

  ObtainHistorySearchHistory(this.text);

  @override
  List<Object?> get props => [];
}
