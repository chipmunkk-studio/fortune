import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FaqEvent extends Equatable {}

class FaqInit extends FaqEvent {
  FaqInit();

  @override
  List<Object?> get props => [];
}

class FaqNextPage extends FaqEvent {
  FaqNextPage();

  @override
  List<Object?> get props => [];
}

class FaqNextPageGetContent extends FaqEvent {
  FaqNextPageGetContent();

  @override
  List<Object?> get props => [];
}
