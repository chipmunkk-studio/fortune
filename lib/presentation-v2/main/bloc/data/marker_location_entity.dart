import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:latlong2/latlong.dart';

class MarkerLocationEntity extends Equatable {
  final int id;
  final LatLng location;
  final GlobalKey globalKey = GlobalKey();

  MarkerLocationEntity({
    required this.id,
    required this.location,
  });

  MarkerLocationEntity copyWith({
    int? id,
    LatLng? location,
    IngredientEntity? ingredient,
    bool? isObtainedUser,
    bool? isProcessing,
  }) {
    return MarkerLocationEntity(
      id: id ?? this.id,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [id, location];
}
