import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:latlong2/latlong.dart';

class MainLocationData extends Equatable {
  final int id;
  final LatLng location;
  final GlobalKey globalKey = GlobalKey();
  final IngredientEntity ingredient;

  MainLocationData({
    this.id = -1,
    required this.location,
    required this.ingredient,
  });

  MainLocationData copyWith({
    int? id,
    LatLng? location,
    IngredientEntity? ingredient,
    bool? isObtainedUser,
    bool? isProcessing,
  }) {
    return MainLocationData(
      id: id ?? this.id,
      location: location ?? this.location,
      ingredient: ingredient ?? this.ingredient,
    );
  }

  @override
  List<Object?> get props => [id, location];
}
