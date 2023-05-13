import 'package:foresh_flutter/data/responses/main/main_history_response.dart';
import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'main_marker_response.dart';

part 'main_response.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class MainResponse extends MainEntity {
  @JsonKey(name: 'id')
  final int id_;
  @JsonKey(name: 'markers')
  final List<MainMarkerResponse>? markers_;
  @JsonKey(name: 'histories')
  final List<MainHistoryResponse>? histories_;
  @JsonKey(name: 'profileImageUrl')
  final String? profileImageUrl_;
  @JsonKey(name: 'coinCount')
  final int? coinCount_;
  @JsonKey(name: 'ticketCount')
  final int? ticketCount_;
  @JsonKey(name: 'remainRoundTime')
  final int? roundTime_;

  MainResponse({
    required this.markers_,
    required this.id_,
    required this.histories_,
    required this.profileImageUrl_,
    required this.coinCount_,
    required this.ticketCount_,
    required this.roundTime_,
  }) : super(
          id: id_,
          markers: markers_
                  ?.map(
                    (e) => MainMarkerEntity(
                      latitude: e.latitude,
                      longitude: e.longitude,
                      grade: e.grade,
                      id: e.id,
                      createdAt: e.createdAt,
                      modifiedAt: e.modifiedAt,
                    ),
                  )
                  .toList() ??
              List.empty(),
          histories: histories_
                  ?.map(
                    (e) => MainHistoryEntity(
                      nickname: e.nickname ?? "",
                      rewardImage: e.rewardImage ?? "",
                      rewardName: e.rewardName ?? "",
                      requestTime: e.requestTime ?? "",
                    ),
                  )
                  .toList() ??
              List.empty(),
          profileImageUrl: profileImageUrl_ ?? "",
          coinCount: coinCount_ ?? 0,
          ticketCount: ticketCount_ ?? 0,
          roundTime: roundTime_ ?? 0,
        );

  factory MainResponse.fromJson(Map<String, dynamic> json) => _$MainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainResponseToJson(this);
}
