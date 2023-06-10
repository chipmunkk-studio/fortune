import 'package:json_annotation/json_annotation.dart';

part 'request_obtain_history_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestObtainHistoryUpdate {
  @JsonKey(name: 'nickname')
  final String nickname;
  @JsonKey(name: 'ingredient_image')
  final String ingredientImage;
  @JsonKey(name: 'kr_ingredient_name')
  final String krIngredientName;
  @JsonKey(name: 'en_ingredient_name')
  final String enIngredientName;
  @JsonKey(name: 'ingredient_type')
  final String ingredientType;
  @JsonKey(name: 'location')
  final String location;
  @JsonKey(name: 'location_kr')
  final String locationKr;

  RequestObtainHistoryUpdate({
    required this.nickname,
    required this.ingredientImage,
    required this.krIngredientName,
    required this.enIngredientName,
    required this.location,
    required this.locationKr,
    required this.ingredientType,
  });

  factory RequestObtainHistoryUpdate.fromJson(Map<String, dynamic> json) => _$RequestObtainHistoryUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestObtainHistoryUpdateToJson(this);
}
