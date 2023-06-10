import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:latlong2/latlong.dart';

class MainLocationData extends Equatable {
  final int id;
  final LatLng location;
  final GlobalKey globalKey = GlobalKey();
  final IngredientEntity ingredient;
  final bool isObtainedUser;

  MainLocationData({
    required this.id,
    required this.location,
    required this.ingredient,
    required this.isObtainedUser,
  });

  @override
  List<Object?> get props => [location, isObtainedUser];
}

// 37.394962
// 127.11074
