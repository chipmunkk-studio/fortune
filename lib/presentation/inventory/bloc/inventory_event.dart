import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class InventoryEvent extends Equatable {}

class InventoryInit extends InventoryEvent {
  InventoryInit();

  @override
  List<Object?> get props => [];
}

class InventoryTabSelected extends InventoryEvent {
  final int select;

  InventoryTabSelected(this.select);

  @override
  List<Object?> get props => [];
}
