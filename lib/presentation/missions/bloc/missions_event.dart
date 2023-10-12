import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/src/ad_containers.dart';

@immutable
abstract class MissionsEvent extends Equatable {}

class MissionsBottomInit extends MissionsEvent {
  MissionsBottomInit();

  @override
  List<Object?> get props => [];
}

class MissionsTopInit extends MissionsEvent {
  MissionsTopInit();

  @override
  List<Object?> get props => [];
}

class MissionsLoadBannerAd extends MissionsEvent {
  final BannerAd? ad;

  MissionsLoadBannerAd(this.ad);

  @override
  List<Object?> get props => [];
}
