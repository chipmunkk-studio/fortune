import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';

@immutable
abstract class RequestPermissionSideEffect extends Equatable {}

class RequestPermissionError extends RequestPermissionSideEffect {
  final FortuneFailureDeprecated error;

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
  final String landingRoutes;

  RequestPermissionSuccess(this.landingRoutes);

  @override
  List<Object?> get props => [];
}
