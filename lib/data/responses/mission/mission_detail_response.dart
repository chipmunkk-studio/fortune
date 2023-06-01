import 'package:foresh_flutter/domain/entities/mission/description_entity.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_detail_entity.dart';
import 'package:foresh_flutter/domain/entities/mission/recipe_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_detail_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionDetailResponse extends MissionDetailEntity {
  @JsonKey(name: 'id')
  final int? id_;
  @JsonKey(name: 'name')
  final String? name_;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl_;
  @JsonKey(name: 'exchangeable')
  final bool? exchangeable_;
  @JsonKey(name: 'recipes')
  final List<Recipe>? recipes_;
  @JsonKey(name: 'descriptions')
  final List<Description>? descriptions_;

  MissionDetailResponse({
    this.id_,
    this.name_,
    this.imageUrl_,
    this.exchangeable_,
    this.recipes_,
    this.descriptions_,
  }) : super(
          id: id_ ?? -1,
          name: name_ ?? '',
          imageUrl: imageUrl_ ?? '',
          exchangeable: exchangeable_ ?? false,
          recipes: recipes_
                  ?.map(
                    (e) => RecipeEntity(
                      name: e.name ?? '',
                      imageUrl: e.imageUrl ?? '',
                      targetCount: e.targetCount ?? 0,
                      userHaveCount: e.userHaveCount ?? 0,
                    ),
                  )
                  .toList() ??
              List.empty(),
          descriptions: descriptions_
                  ?.map(
                    (e) => DescriptionEntity(
                      title: e.title ?? '',
                      content: e.content ?? '',
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory MissionDetailResponse.fromJson(Map<String, dynamic> json) => _$MissionDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionDetailResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class Recipe {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'targetCount')
  final int? targetCount;
  @JsonKey(name: 'userHaveCount')
  final int? userHaveCount;

  Recipe({this.name, this.imageUrl, this.targetCount, this.userHaveCount});

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class Description {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'content')
  final String? content;

  Description({this.title, this.content});

  factory Description.fromJson(Map<String, dynamic> json) => _$DescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionToJson(this);
}
