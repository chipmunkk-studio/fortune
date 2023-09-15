import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MyPageEvent extends Equatable {}

class MyPageInit extends MyPageEvent {
  MyPageInit();

  @override
  List<Object?> get props => [];
}

class MyPageUpdateProfile extends MyPageEvent {
  final String filePath;

  MyPageUpdateProfile(this.filePath);

  @override
  List<Object?> get props => [];
}

class MyPageUpdatePushAlarm extends MyPageEvent {
  final bool isOn;

  MyPageUpdatePushAlarm(this.isOn);

  @override
  List<Object?> get props => [];
}
