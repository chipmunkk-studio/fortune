import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_user_ranking_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class FortuneUserRankingResponse extends FortuneUserRankingEntity {
  @JsonKey(name: 'ticket')
  final int? ticket_;
  @JsonKey(name: 'marker_obtain_count')
  final int? markerObtainCount_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  FortuneUserRankingResponse({
    required this.ticket_,
    required this.markerObtainCount_,
    required this.createdAt_,
  }) : super(
          ticket: ticket_ ?? 0,
          markerObtainCount: markerObtainCount_ ?? 0,
          createdAt: createdAt_ ?? '',
        );

  factory FortuneUserRankingResponse.fromJson(Map<String, dynamic> json) => _$FortuneUserRankingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneUserRankingResponseToJson(this);
}
