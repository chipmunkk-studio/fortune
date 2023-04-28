import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MainLocationData {
  final int id;
  final LatLng location;
  final GlobalKey widgetKey = GlobalKey();
  final bool disappeared;
  final int grade;

  MainLocationData({
    required this.id,
    required this.location,
    required this.disappeared,
    this.grade = -1,
  });
}
