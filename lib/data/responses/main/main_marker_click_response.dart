import 'package:foresh_flutter/data/responses/main/main_marker_click_info_response.dart';
import 'package:foresh_flutter/domain/entities/marker/marker_click_entity.dart';
import 'package:foresh_flutter/domain/entities/marker/marker_click_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main_marker_click_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class MainMarkerClickResponse extends MarkerClickEntity {
  @JsonKey(name: 'remainTicketCount')
  final int? remainTicketCount_;
  @JsonKey(name: 'obtainMarker')
  final MainMarkerClickInfoResponse? obtainMarker_;

  MainMarkerClickResponse({
    required this.remainTicketCount_,
    required this.obtainMarker_,
  }) : super(
          remainTicketCount: remainTicketCount_ ?? 0,
          obtainMarker: obtainMarker_ ?? MarkerClickInfoEntity.initial(),
        );

  factory MainMarkerClickResponse.fromJson(Map<String, dynamic> json) => _$MainMarkerClickResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainMarkerClickResponseToJson(this);
}
