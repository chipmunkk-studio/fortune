import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RequestPermissionEvent extends Equatable {}

class RequestPermissionInit extends RequestPermissionEvent {
  RequestPermissionInit();

  @override
  List<Object?> get props => [];
}

class RequestPermissionNext extends RequestPermissionEvent {
  RequestPermissionNext();

  @override
  List<Object?> get props => [];
}