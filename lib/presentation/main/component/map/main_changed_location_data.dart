import 'package:json_annotation/json_annotation.dart';

part 'main_changed_location_data.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class MainChangedLocationData {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'latitude')
  double latitude;
  @JsonKey(name: 'longitude')
  double longitude;
  @JsonKey(name: 'userId')
  int userId;
  @JsonKey(name: 'nickname')
  String nickname;

  MainChangedLocationData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.nickname,
  });

  factory MainChangedLocationData.fromJson(Map<String, dynamic> json) => _$MainChangedLocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$MainChangedLocationDataToJson(this);
}
