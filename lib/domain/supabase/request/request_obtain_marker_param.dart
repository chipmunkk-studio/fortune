import 'package:fortune/presentation/main/component/map/main_location_data.dart';

class RequestObtainMarkerParam {
  final MainLocationData marker;
  final String kLocation;

  RequestObtainMarkerParam({
    required this.marker,
    required this.kLocation,
  });
}
