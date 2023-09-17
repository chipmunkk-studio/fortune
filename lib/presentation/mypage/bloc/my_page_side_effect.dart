import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class MyPageSideEffect extends Equatable {}

class MyPageError extends MyPageSideEffect {
  final FortuneFailure error;

  MyPageError(this.error);

  @override
  List<Object?> get props => [];
}