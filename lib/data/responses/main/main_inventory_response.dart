import 'package:foresh_flutter/domain/entities/inventory_entity.dart';
import 'package:foresh_flutter/domain/entities/marker_grade_entity.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main_inventory_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MainInventoryResponse extends InventoryEntity {
  @JsonKey(name: 'nickname')
  final String? nickname_;
  @JsonKey(name: 'profileImage')
  final String? profileImage_;
  @JsonKey(name: 'markers')
  final List<MainInventoryMarkerResponse>? markers_;

  MainInventoryResponse({
    required this.nickname_,
    required this.profileImage_,
    required this.markers_,
  }) : super(
          nickname: nickname_ ?? "",
          profileImage: profileImage_ ?? "",
          markers: markers_
                  ?.map(
                    (e) => InventoryMarkerEntity(
                      grade: getMarkerGradeIconInfo(e.grade ?? 0),
                      count: e.count ?? "",
                      open: e.open ?? false,
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory MainInventoryResponse.fromJson(Map<String, dynamic> json) => _$MainInventoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainInventoryResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class MainInventoryMarkerResponse {
  @JsonKey(name: 'grade')
  final int? grade;
  @JsonKey(name: 'count')
  final String? count;
  @JsonKey(name: 'open')
  final bool? open;

  MainInventoryMarkerResponse({
    required this.grade,
    required this.count,
    required this.open,
  });

  factory MainInventoryMarkerResponse.fromJson(Map<String, dynamic> json) =>
      _$MainInventoryMarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainInventoryMarkerResponseToJson(this);
}
