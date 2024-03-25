import 'package:fortune/data/remote/response/marker_response.dart';
import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fortune_response_ext.dart';

part 'marker_list_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MarkerListResponse extends MarkerListEntity {
  @JsonKey(name: 'list')
  final List<MarkerResponse>? list_;

  MarkerListResponse({
    this.list_,
  }) : super(
          list: list_
                  ?.map(
                    (e) => MarkerEntity(
                      id: e.id ?? '',
                      name: e.name ?? '',
                      imageUrl: e.imageUrl ?? '',
                      itemType: getMarkerItemType(e.itemType),
                      latitude: e.latitude ?? 0.0,
                      longitude: e.longitude ?? 0.0,
                      cost: e.cost ?? 0,
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory MarkerListResponse.fromJson(Map<String, dynamic> json) => _$MarkerListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerListResponseToJson(this);
}
