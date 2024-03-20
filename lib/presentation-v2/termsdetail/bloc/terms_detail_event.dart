import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class TermsDetailEvent extends Equatable {}

class TermsDetailInit extends TermsDetailEvent {
  final int index;

  TermsDetailInit(this.index);

  @override
  List<Object?> get props => [];
}
