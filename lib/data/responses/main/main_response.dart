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
  @JsonKey(name: 'chargedTickets')
  final int? chargeTicketCnt_;
  @JsonKey(name: 'normalTickets')
  final int? normalTicketsCnt_;
  @JsonKey(name: 'remainRoundTime')
  final int? roundTime_;

  MainResponse({
    required this.markers_,
    required this.id_,
    required this.histories_,
    required this.profileImageUrl_,
    required this.chargeTicketCnt_,
    required this.normalTicketsCnt_,
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
                      latitude: e.latitude,
                      longitude: e.longitude,
                      grade: e.grade,
                      id: e.id,
                      createdAt: e.createdAt,
                      modifiedAt: e.modifiedAt,
                      userId: e.userId,
                      nickname: e.nickname,
                      markerId: e.markerId,
                    ),
                  )
                  .toList() ??
              List.empty(),
          profileImageUrl: profileImageUrl_ ?? "",
          chargeTicketCnt: chargeTicketCnt_ ?? 0,
          normalTicketsCnt: normalTicketsCnt_ ?? 0,
          roundTime: roundTime_ ?? 0,
        );

  factory MainResponse.fromJson(Map<String, dynamic> json) => _$MainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainResponseToJson(this);
}
