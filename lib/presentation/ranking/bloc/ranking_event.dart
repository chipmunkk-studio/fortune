import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RankingEvent extends Equatable {}

class RankingInit extends RankingEvent {
  RankingInit();

  @override
  List<Object?> get props => [];
}

class RankingNextPage extends RankingEvent {
  RankingNextPage();

  @override
  List<Object?> get props => [];
}
