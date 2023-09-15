import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NoticesEvent extends Equatable {}

class NoticesInit extends NoticesEvent {
  NoticesInit();

  @override
  List<Object?> get props => [];
}

class NoticesNextPage extends NoticesEvent {
  NoticesNextPage();

  @override
  List<Object?> get props => [];
}

class NoticesNextPageGetContent extends NoticesEvent {
  NoticesNextPageGetContent();

  @override
  List<Object?> get props => [];
}
