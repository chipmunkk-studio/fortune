import 'package:json_annotation/json_annotation.dart';

part 'picked_item_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class PickedItemResponse {
  @JsonKey(name: 'type')
  final String? type;

  PickedItemResponse({this.type});

  factory PickedItemResponse.fromJson(Map<String, dynamic> json) => _$PickedItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PickedItemResponseToJson(this);
}
