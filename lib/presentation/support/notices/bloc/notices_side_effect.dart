import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class NoticesSideEffect extends Equatable {}

class NoticesError extends NoticesSideEffect {
  final FortuneFailure error;

  NoticesError(this.error);

  @override
  List<Object?> get props => [];
}