import 'package:foresh_flutter/domain/entities/mission/description_entity.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_entity.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_card_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionResponse extends MissionEntity {
  @JsonKey(name: 'totalMarkerCount')
  final int? totalMarkerCount_;
  @JsonKey(name: 'rewards')
  final List<Reward>? missions_;

  MissionResponse({
    this.totalMarkerCount_,
    this.missions_,
  }) : super(
          totalMarkerCount: totalMarkerCount_ ?? 0,
          missions: missions_
                  ?.map(
                    (e) => MissionCardEntity(
                      id: e.id ?? -1,
                      name: e.name ?? "",
                      imageUrl: e.imageUrl ?? "",
                      stock: e.stock ?? 0,
                      remainedStock: e.remainedStock ?? 0,
                      targetMarkerCount: e.targetMarkerCount ?? 0,
                      userHaveMarkerCount: e.userHaveMarkerCount ?? 0,
                      descriptions: e.descriptions
                              ?.map(
                                (e) => DescriptionEntity(
                                  title: e.title ?? "",
                                  content: e.content ?? "",
                                ),
                              )
                              .toList() ??
                          List.empty(),
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory MissionResponse.fromJson(Map<String, dynamic> json) => _$MissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class Reward {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'stock')
  final int? stock;
  @JsonKey(name: 'remainedStock')
  final int? remainedStock;
  @JsonKey(name: 'targetMarkerCount')
  final int? targetMarkerCount;
  @JsonKey(name: 'userHaveMarkerCount')
  final int? userHaveMarkerCount;
  @JsonKey(name: 'descriptions')
  final List<Description>? descriptions;

  Reward(
      {this.id,
      this.name,
      this.imageUrl,
      this.stock,
      this.remainedStock,
      this.targetMarkerCount,
      this.userHaveMarkerCount,
      this.descriptions});

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  Map<String, dynamic> toJson() => _$RewardToJson(this);
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
