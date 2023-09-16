import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/notification/notification_response.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:location/location.dart';

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
  final LocationData newLoc;

  MainMyLocationChange(this.newLoc);

  @override
  List<Object?> get props => [];
}

class MainMarkerClick extends MainEvent {
  final MainLocationData data;
  final GlobalKey globalKey;

  MainMarkerClick({
    required this.data,
    required this.globalKey,
  });

  @override
  List<Object?> get props => [data];
}

class MainMarkerObtain extends MainEvent {
  final MainLocationData data;
  final GlobalKey key;

  MainMarkerObtain(
    this.data,
    this.key,
  );

  @override
  List<Object?> get props => [data];
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
