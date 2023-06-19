import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/presentation/main/component/map/main_location_data.dart';
import 'package:location/location.dart';

import '../../../../core/error/fortune_app_failures.dart';

@immutable
abstract class MainSideEffect extends Equatable {}

class MainError extends MainSideEffect {
  final FortuneFailure error;

  MainError(this.error);

  @override
  List<Object?> get props => [];
}

class MainLocationChangeListenSideEffect extends MainSideEffect {
  final Location myLocation;
  final LocationData myLocationData;

  MainLocationChangeListenSideEffect(
    this.myLocation,
    this.myLocationData,
  );

  @override
  List<Object?> get props => [];
}

class MainMarkerClickSideEffect extends MainSideEffect {
  final GlobalKey key;
  final MainLocationData data;

  MainMarkerClickSideEffect({
    required this.key,
    required this.data,
  });

  @override
  List<Object?> get props => [key];
}

class MainRequireLocationPermission extends MainSideEffect {
  MainRequireLocationPermission();

  @override
  List<Object?> get props => [];
}

class MainRequireInCircleMeters extends MainSideEffect {
  final double meters;

  MainRequireInCircleMeters(this.meters);

  @override
  List<Object?> get props => [];
}

class MainSchemeLandingPage extends MainSideEffect {
  final String landingRoute;
  final String searchText;

  MainSchemeLandingPage(
    this.landingRoute, {
    this.searchText = '',
  });

  @override
  List<Object?> get props => [landingRoute];
}
