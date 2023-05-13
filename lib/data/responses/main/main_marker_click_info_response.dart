import 'package:foresh_flutter/domain/entities/marker/marker_click_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main_marker_click_info_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class MainMarkerClickInfoResponse extends MarkerClickInfoEntity {
  @JsonKey(name: 'message')
  final String? message_;
  @JsonKey(name: 'grade')
  final int? grade_;

  const MainMarkerClickInfoResponse({
    required this.message_,
    required this.grade_,
  }) : super(
          message: message_ ?? "",
          grade: grade_ ?? 0,
        );

  factory MainMarkerClickInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$MainMarkerClickInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainMarkerClickInfoResponseToJson(this);
}
