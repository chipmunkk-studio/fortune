import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/locale.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/ingredient_response.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'obtain_history_response.g.dart';

enum ObtainHistoryColumn {
  id,
  users,
  ingredient,
  markerId,
  nickName,
  krIngredientName,
  enIngredientName,
  locationName,
  isReward,
  createdAt,
}

extension ObtainHistoryColumnExtension on ObtainHistoryColumn {
  String get name {
    switch (this) {
      case ObtainHistoryColumn.id:
        return 'id';
      case ObtainHistoryColumn.users:
        return 'user';
      case ObtainHistoryColumn.ingredient:
        return 'ingredient';
      case ObtainHistoryColumn.markerId:
        return 'marker_id';
      case ObtainHistoryColumn.nickName:
        return 'nickname';
      case ObtainHistoryColumn.krIngredientName:
        return 'kr_ingredient_name';
      case ObtainHistoryColumn.enIngredientName:
        return 'en_ingredient_name';
      case ObtainHistoryColumn.locationName:
        return 'location_name';
      case ObtainHistoryColumn.isReward:
        return 'is_reward';
      case ObtainHistoryColumn.createdAt:
        return 'created_at';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class ObtainHistoryResponse extends ObtainHistoryEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'user')
  final FortuneUserResponse? user_;
  @JsonKey(name: 'ingredient')
  final IngredientResponse? ingredient_;
  @JsonKey(name: 'marker_id')
  final String? markerId_;
  @JsonKey(name: 'nickname')
  final String? nickName_;
  @JsonKey(name: 'kr_ingredient_name')
  final String? krIngredientName_;
  @JsonKey(name: 'en_ingredient_name')
  final String? enIngredientName_;
  @JsonKey(name: 'location_name')
  final String? locationName_;
  @JsonKey(name: 'is_reward')
  final bool? isReward_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  ObtainHistoryResponse({
    required this.id_,
    required this.user_,
    required this.markerId_,
    required this.ingredient_,
    required this.createdAt_,
    required this.nickName_,
    required this.krIngredientName_,
    required this.enIngredientName_,
    required this.locationName_,
    required this.isReward_,
  }) : super(
          id: id_?.toInt() ?? -1,
          markerId: markerId_ ?? '',
          user: user_ ?? FortuneUserEntity.empty(),
          ingredient: ingredient_ ?? IngredientEntity.empty(),
          locationName: locationName_ ?? '',
          ingredientName: getLocaleContent(en: enIngredientName_ ?? '', kr: krIngredientName_ ?? ''),
          nickName: nickName_ ?? FortuneTr.msgUnknownUser,
          isReward: isReward_ ?? true,
          createdAt: createdAt_ ?? '',
        );

  factory ObtainHistoryResponse.fromJson(Map<String, dynamic> json) => _$ObtainHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ObtainHistoryResponseToJson(this);
}
