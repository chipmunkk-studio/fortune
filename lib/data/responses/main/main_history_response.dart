import 'package:json_annotation/json_annotation.dart';

part 'main_history_response.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class MainHistoryResponse {
  @JsonKey(name: 'latitude')
  double latitude;
  @JsonKey(name: 'longitude')
  double longitude;
  @JsonKey(name: 'grade')
  int grade;
  @JsonKey(name: 'userId')
  int userId;
  @JsonKey(name: 'nickname')
  String nickname;
  @JsonKey(name: 'markerId')
  int markerId;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'createdAt')
  String createdAt;
  @JsonKey(name: 'modifiedAt')
  String modifiedAt;

  MainHistoryResponse({
    required this.latitude,
    required this.longitude,
    required this.grade,
    required this.userId,
    required this.nickname,
    required this.markerId,
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory MainHistoryResponse.fromJson(Map<String, dynamic> json) => _$MainHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainHistoryResponseToJson(this);
}
