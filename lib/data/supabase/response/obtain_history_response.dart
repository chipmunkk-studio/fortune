import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/ingredient_response.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'obtain_history_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class ObtainHistoryResponse extends ObtainHistoryEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'user')
  final FortuneUserResponse user_;
  @JsonKey(name: 'ingredient')
  final IngredientResponse ingredient_;
  @JsonKey(name: 'marker_id')
  final String? markerId_;
  @JsonKey(name: 'nickname')
  final String nickName_;
  @JsonKey(name: 'ingredient_name')
  final String ingredientName_;
  @JsonKey(name: 'location_name')
  final String? locationName_;
  @JsonKey(name: 'is_reward')
  final bool isReward_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  ObtainHistoryResponse({
    required this.id_,
    required this.user_,
    required this.markerId_,
    required this.ingredient_,
    required this.createdAt_,
    required this.nickName_,
    required this.ingredientName_,
    required this.locationName_,
    required this.isReward_,
  }) : super(
          id: id_.toInt(),
          markerId: markerId_ ?? '',
          user: user_,
          ingredient: ingredient_,
          locationName: locationName_ ?? '',
          ingredientName: ingredientName_,
          nickName: nickName_,
          isReward: isReward_,
          createdAt: createdAt_,
        );

  factory ObtainHistoryResponse.fromJson(Map<String, dynamic> json) => _$ObtainHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ObtainHistoryResponseToJson(this);
}
