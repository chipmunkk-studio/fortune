import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/presentation-v2/fortune_ad/admanager/fortune_ad.dart';
import 'package:latlong2/latlong.dart';

@immutable
abstract class MainSideEffect extends Equatable {}

class MainError extends MainSideEffect {
  final FortuneFailure error;

  MainError(this.error);

  @override
  List<Object?> get props => [];
}

class MainLocationChangeListenSideEffect extends MainSideEffect {
  final LatLng location;
  final double destZoom;
  final bool isInitialize;

  MainLocationChangeListenSideEffect({
    required this.location,
    required this.destZoom,
    this.isInitialize = false,
  });

  @override
  List<Object?> get props => [];
}

class MainRequireLocationPermission extends MainSideEffect {
  MainRequireLocationPermission();

  @override
  List<Object?> get props => [];
}

class MainShowObtainDialog extends MainSideEffect {
  final MarkerEntity marker;
  final int timestamp;

  final LatLng location;

  MainShowObtainDialog({
    required this.marker,
    required this.timestamp,
    required this.location,
  });

  @override
  List<Object?> get props => [];
}

class MainShowAdDialog extends MainSideEffect {
  final int ts;
  final MarkerEntity targetMarker;
  final Future<FortuneAdState?> ad;

  MainShowAdDialog({
    required this.ts,
    required this.targetMarker,
    required this.ad,
  });

  @override
  List<Object?> get props => [];
}

class MainObtainMarker extends MainSideEffect {
  final MarkerEntity marker;
  final int timestamp;

  final LatLng location;

  MainObtainMarker({
    required this.marker,
    required this.timestamp,
    required this.location,
  });

  @override
  List<Object?> get props => [];
}

class MainSchemeLandingPage extends MainSideEffect {
  final String landingRoute;

  MainSchemeLandingPage(this.landingRoute);

  @override
  List<Object?> get props => [landingRoute];
}

class MainRequireInCircleMetersEvent extends MainSideEffect {
  final double distance;

  MainRequireInCircleMetersEvent(this.distance);

  @override
  List<Object?> get props => throw UnimplementedError();
}
