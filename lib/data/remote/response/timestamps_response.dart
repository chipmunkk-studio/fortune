import 'package:fortune/domain/entity/timestamps_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timestamps_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class TimestampsResponse extends TimestampsEntity {
  @JsonKey(name: 'pig')
  final int? pig_;
  @JsonKey(name: 'random')
  final int? random_;
  @JsonKey(name: 'marker')
  final int? marker_;
  @JsonKey(name: 'ad')
  final int? ad_;
  @JsonKey(name: 'mission')
  final int? mission_;

  TimestampsResponse({
    this.pig_,
    this.random_,
    this.marker_,
    this.ad_,
    this.mission_,
  }) : super(
          pig: pig_ ?? -1,
          random: random_ ?? -1,
          marker: marker_ ?? -1,
          ad: ad_ ?? -1,
          mission: mission_ ?? -1,
        );

  factory TimestampsResponse.fromJson(Map<String, dynamic> json) => _$TimestampsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TimestampsResponseToJson(this);
}
