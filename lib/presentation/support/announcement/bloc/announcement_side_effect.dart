import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';


@immutable
abstract class AnnouncementSideEffect extends Equatable {}

class AnnouncementError extends AnnouncementSideEffect {
  final FortuneFailure error;

  AnnouncementError(this.error);

  @override
  List<Object?> get props => [];
}