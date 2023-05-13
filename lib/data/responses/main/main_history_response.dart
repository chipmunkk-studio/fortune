import 'package:json_annotation/json_annotation.dart';

part 'main_history_response.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class MainHistoryResponse {
  @JsonKey(name: 'rewardName')
  String? rewardName;
  @JsonKey(name: 'rewardImage')
  String? rewardImage;
  @JsonKey(name: 'requestTime')
  String? requestTime;
  @JsonKey(name: 'nickname')
  String? nickname;

  MainHistoryResponse({
    required this.nickname,
    required this.rewardImage,
    required this.requestTime,
    required this.rewardName,
  });

  factory MainHistoryResponse.fromJson(Map<String, dynamic> json) => _$MainHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainHistoryResponseToJson(this);
}
