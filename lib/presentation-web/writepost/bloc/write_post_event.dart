import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class WritePostEvent extends Equatable {}

class WritePostInit extends WritePostEvent {
  WritePostInit();

  @override
  List<Object?> get props => [];
}

class WritePostRequest extends WritePostEvent {
  final String postJson;

  WritePostRequest(this.postJson);

  @override
  List<Object?> get props => [];
}
