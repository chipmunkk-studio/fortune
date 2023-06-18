import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../component/map/main_location_data.dart';

@immutable
abstract class MainEvent extends Equatable {}

class MainInit extends MainEvent {
  MainInit();

  @override
  List<Object?> get props => [];
}

class Main extends MainEvent {
  Main();

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
  final MainLocationData data;
  final double distance;
  final GlobalKey globalKey;

  MainMarkerClick({
    required this.data,
    required this.distance,
    required this.globalKey,
  });

  @override
  List<Object?> get props => [distance, data];
}

class MainTimeOver extends MainEvent {
  MainTimeOver();

  @override
  List<Object?> get props => [];
}

class MainLandingPage extends MainEvent {
  final String? landingPage;

  MainLandingPage(this.landingPage);

  @override
  List<Object?> get props => [];
}
