import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FaqsEvent extends Equatable {}

class FaqInit extends FaqsEvent {
  FaqInit();

  @override
  List<Object?> get props => [];
}

class FaqNextPage extends FaqsEvent {
  FaqNextPage();

  @override
  List<Object?> get props => [];
}

class FaqNextPageGetContent extends FaqsEvent {
  FaqNextPageGetContent();

  @override
  List<Object?> get props => [];
}
