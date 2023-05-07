import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class InventoryEvent extends Equatable {}

class InventoryInit extends InventoryEvent {
  InventoryInit();

  @override
  List<Object?> get props => [];
}
