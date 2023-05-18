import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AnnouncementEvent extends Equatable {}

class AnnouncementInit extends AnnouncementEvent {
  AnnouncementInit();

  @override
  List<Object?> get props => [];
}

class AnnouncementNextPage extends AnnouncementEvent {
  AnnouncementNextPage();

  @override
  List<Object?> get props => [];
}
