import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:fortune/core/notification/notification_response.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:latlong2/latlong.dart';

@immutable
abstract class MainEvent extends Equatable {}

class MainInit extends MainEvent {
  final FortuneNotificationEntity? notificationEntity;

  MainInit({this.notificationEntity});

  @override
  List<Object?> get props => [];
}

class MainOnAdShowComplete extends MainEvent {
  final FortuneUserEntity user;

  MainOnAdShowComplete(this.user);

  @override
  List<Object?> get props => [];
}

class MainObtainSuccess extends MainEvent {
  final MarkerObtainEntity entity;

  MainObtainSuccess(this.entity);

  @override
  List<Object?> get props => [];
}


class MainInitMyLocation extends MainEvent {
  final LatLng location;

  MainInitMyLocation(this.location);

  @override
  List<Object?> get props => [];
}

class MainMarkerClick extends MainEvent {
  final MarkerEntity entity;

  MainMarkerClick(this.entity);

  @override
  List<Object?> get props => [];
}

class MainMarkerList extends MainEvent {
  final LatLng location;

  MainMarkerList(this.location);

  @override
  List<Object?> get props => [];
}

class MainLocationChange extends MainEvent {
  final LatLng location;

  MainLocationChange(this.location);

  @override
  List<Object?> get props => [];
}

class MainLandingPage extends MainEvent {
  final FortuneNotificationEntity entity;

  MainLandingPage(this.entity);

  @override
  List<Object?> get props => [entity];
}

class MainSetRewardAd extends MainEvent {
  final RewardedAd? ad;

  MainSetRewardAd(this.ad);

  @override
  List<Object?> get props => [ad];
}

class MainRequireInCircleMetersEvent extends MainEvent {
  final double distance;

  MainRequireInCircleMetersEvent(this.distance);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class MainCompassRotate extends MainEvent {
  final CompassEvent data;

  MainCompassRotate(this.data);

  @override
  List<Object?> get props => [];
}
