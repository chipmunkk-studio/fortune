import 'package:json_annotation/json_annotation.dart';

part 'request_main.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class RequestMain {
  @JsonKey(name: 'latitude')
  double? latitude;
  @JsonKey(name: 'longitude')
  double? longitude;

  RequestMain({
    required this.latitude,
    required this.longitude,
  });

  factory RequestMain.fromJson(Map<String, dynamic> json) => _$RequestMainFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMainToJson(this);
}
