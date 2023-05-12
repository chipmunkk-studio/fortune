import 'package:json_annotation/json_annotation.dart';

part 'main_history_response.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class MainHistoryResponse {
  @JsonKey(name: 'productName')
  String? productName;
  @JsonKey(name: 'productImage')
  String? productImage;
  @JsonKey(name: 'requestTime')
  String? requestTime;
  @JsonKey(name: 'nickname')
  String? nickname;

  MainHistoryResponse({
    required this.nickname,
    required this.productImage,
    required this.requestTime,
    required this.productName,
  });

  factory MainHistoryResponse.fromJson(Map<String, dynamic> json) => _$MainHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainHistoryResponseToJson(this);
}
