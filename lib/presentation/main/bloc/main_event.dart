import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/presentation/main/component/map/main_changed_location_data.dart';
import 'package:location/location.dart';

import '../component/map/main_location_data.dart';

@immutable
abstract class MainEvent extends Equatable {}

class MainInit extends MainEvent {
  MainInit();

  @override
  List<Object?> get props => [];
}

class MainGetLocation extends MainEvent {
  MainGetLocation();

  @override
  List<Object?> get props => [];
}

class MainMyLocationChange extends MainEvent {
  final LocationData newLoc;

  MainMyLocationChange(this.newLoc);

  @override
  List<Object?> get props => [];
}

class MainMarkerClick extends MainEvent {
  final int id;
  final GlobalKey widgetKey;
  final double latitude;
  final double longitude;
  final double distance;

  MainMarkerClick({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.widgetKey,
  });

  @override
  List<Object?> get props => [id];
}

class MainRequestPermission extends MainEvent {
  MainRequestPermission();

  @override
  List<Object?> get props => [];
}

class MainMarkerLocationChange extends MainEvent {
  final MainChangedLocationData entity;

  MainMarkerLocationChange(
    this.entity,
  );

  @override
  List<Object?> get props => [entity];
}

class MainChangeNewMarkers extends MainEvent {
  final List<MainLocationData> newMarkers;

  MainChangeNewMarkers(this.newMarkers);

  @override
  List<Object?> get props => [newMarkers];
}

class MainShatteredMarkerRefresh extends MainEvent {
  final int id;

  MainShatteredMarkerRefresh(this.id);

  @override
  List<Object?> get props => [];
}

class MainRefresh extends MainEvent {
  MainRefresh();

  @override
  List<Object?> get props => [];
}

class MainRoundOver extends MainEvent {
  MainRoundOver();

  @override
  List<Object?> get props => [];
}
