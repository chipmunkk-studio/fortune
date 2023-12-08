import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/support/app_update_view_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:fortune/presentation/main/component/map/main_location_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/src/ad_containers.dart';

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
  final Position myLocation;

  MainLocationChangeListenSideEffect(
    this.myLocation,
  );

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
  final MainLocationData data;
  final GlobalKey key;
  final bool isShowAd;
  final FortuneUserEntity? user;
  final RewardedAd? ad;

  MainShowObtainDialog({
    required this.data,
    required this.key,
    required this.isShowAd,
    this.user,
    this.ad,
  });

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

class MainShowAppUpdate extends MainSideEffect {
  final AppUpdateViewEntity entity;

  MainShowAppUpdate({
    required this.entity,
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

class MainRequiredTicket extends MainSideEffect {
  final int requiredTicket;

  MainRequiredTicket(this.requiredTicket);

  @override
  List<Object?> get props => [];
}

class MainNavigateOpenRandomBox extends MainSideEffect {
  final MainLocationData data;
  final FortuneUserEntity? user;
  final RewardedAd? ad;
  final GiftboxType type;

  MainNavigateOpenRandomBox({
    required this.data,
    required this.user,
    required this.ad,
    required this.type,
  });

  @override
  List<Object?> get props => [];
}
