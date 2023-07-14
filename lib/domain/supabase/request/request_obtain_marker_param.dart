import 'package:foresh_flutter/presentation/main/component/map/main_location_data.dart';

class RequestObtainMarkerParam {
  final MainLocationData marker;
  final String kLocation;
  final String eLocation;

  RequestObtainMarkerParam({
    required this.marker,
    required this.kLocation,
    required this.eLocation,
  });
}
