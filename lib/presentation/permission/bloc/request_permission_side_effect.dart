import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';

@immutable
abstract class RequestPermissionSideEffect extends Equatable {}

class RequestPermissionError extends RequestPermissionSideEffect {
  final FortuneFailure error;

  RequestPermissionError(this.error);

  @override
  List<Object?> get props => [];
}

class RequestPermissionStart extends RequestPermissionSideEffect {
  @override
  List<Object?> get props => [];
}


class RequestPermissionFail extends RequestPermissionSideEffect {
  @override
  List<Object?> get props => [];
}

class RequestPermissionSuccess extends RequestPermissionSideEffect {
  @override
  List<Object?> get props => [];
}