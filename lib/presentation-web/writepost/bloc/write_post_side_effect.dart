import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class WritePostSideEffect extends Equatable {}

class WritePostError extends WritePostSideEffect {
  final FortuneFailure error;

  WritePostError(this.error);

  @override
  List<Object?> get props => [];
}