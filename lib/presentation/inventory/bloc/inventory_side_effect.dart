import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';


@immutable
abstract class InventorySideEffect extends Equatable {}

class InventoryError extends InventorySideEffect {
  final FortuneFailure error;

  InventoryError(this.error);

  @override
  List<Object?> get props => [];
}