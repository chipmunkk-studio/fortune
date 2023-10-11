import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/notification/notification_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../component/map/main_location_data.dart';

@immutable
abstract class MainEvent extends Equatable {}

class MainInit extends MainEvent {
  final FortuneNotificationEntity? notificationEntity;

  MainInit({this.notificationEntity});

  @override
  List<Object?> get props => [];
}

class Main extends MainEvent {
  Main();

  @override
  List<Object?> get props => [];
}

class MainMyLocationChange extends MainEvent {
  final Position newLoc;

  MainMyLocationChange(this.newLoc);

  @override
  List<Object?> get props => [];
}

class MainMarkerClick extends MainEvent {
  final MainLocationData data;
  final GlobalKey globalKey;
  final double distance;

  MainMarkerClick({
    required this.data,
    required this.globalKey,
    required this.distance,
  });

  @override
  List<Object?> get props => [data];
}

class MainMarkerObtain extends MainEvent {
  final MainLocationData data;
  final GlobalKey key;

  MainMarkerObtain({
    required this.data,
    required this.key,
  });

  @override
  List<Object?> get props => [data];
}

class MainScreenFreeze extends MainEvent {
  final bool flag;
  final MainLocationData data;

  MainScreenFreeze({
    required this.flag,
    required this.data,
  });

  @override
  List<Object?> get props => [flag];
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
