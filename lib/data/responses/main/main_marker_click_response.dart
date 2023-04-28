import 'package:foresh_flutter/domain/entities/marker_click_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main_marker_click_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class MainMarkerClickResponse extends MarkerClickEntity {
  @JsonKey(name: 'chargedTickets')
  final int? chargedTickets_;
  @JsonKey(name: 'normalTickets')
  final int? normalTickets_;
  @JsonKey(name: 'isNew')
  final bool? isNew_;

  const MainMarkerClickResponse({
    required this.chargedTickets_,
    required this.normalTickets_,
    required this.isNew_,
  }) : super(
          chargedTickets: chargedTickets_ ?? 0,
          normalTickets: normalTickets_ ?? 0,
          isNew: isNew_ ?? false,
        );

  factory MainMarkerClickResponse.fromJson(Map<String, dynamic> json) => _$MainMarkerClickResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainMarkerClickResponseToJson(this);
}
