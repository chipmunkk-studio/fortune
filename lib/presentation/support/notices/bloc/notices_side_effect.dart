import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class NoticesSideEffect extends Equatable {}

class NoticesError extends NoticesSideEffect {
  final FortuneFailureDeprecated error;

  NoticesError(this.error);

  @override
  List<Object?> get props => [];
}