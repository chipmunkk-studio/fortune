import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/support/app_update_view_entity.dart';
import 'package:fortune/presentation-v2/admanager/fortune_ad.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/src/ad_containers.dart';
import 'package:latlong2/latlong.dart';

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

class MainMarkerObtainSuccessSideEffect extends MainSideEffect {
  final GlobalKey key;
  final MainLocationData data;
  final bool hasAnimation;

  MainMarkerObtainSuccessSideEffect({
    required this.key,
    required this.data,
    required this.hasAnimation,
  });

  @override
  List<Object?> get props => [key];
}

class MainMarkerClickSideEffect extends MainSideEffect {
  MainMarkerClickSideEffect();

  @override
  List<Object?> get props => [];
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

  MainShowAdDialog({
    required this.ts,
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

class MainShowAppUpdate extends MainSideEffect {
  final bool isAlert;
  final bool isForceUpdate;
  final String title;
  final String content;

  MainShowAppUpdate({
    required this.isAlert,
    required this.title,
    required this.content,
    required this.isForceUpdate,
  });

  @override
  List<Object?> get props => [];
}

class MainRotateEffect extends MainSideEffect {
  final double nextData;
  final double prevData;

  MainRotateEffect({
    required this.prevData,
    required this.nextData,
  });

  @override
  List<Object?> get props => [];
}
