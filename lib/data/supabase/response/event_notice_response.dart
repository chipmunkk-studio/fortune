import 'package:foresh_flutter/domain/supabase/entity/event_notice_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_notice_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EventNoticeResponse extends EventNoticeEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'searchText')
  final String? searchText_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'ticket')
  final int ticket_;
  @JsonKey(name: 'landingRoute')
  final String? landingRoute_;
  @JsonKey(name: 'createdAt')
  final String createdAt_;

  EventNoticeResponse({
    required this.createdAt_,
    required this.id_,
    required this.searchText_,
    required this.type_,
    required this.ticket_,
    required this.landingRoute_,
  }) : super(
          id: id_?.toInt() ?? 0,
          ticket: ticket_,
          searchText: searchText_ ?? '',
          type: type_,
          landingRoute: landingRoute_ ?? Routes.userNoticesRoute,
          createdAt: createdAt_,
        );

  factory EventNoticeResponse.fromJson(Map<String, dynamic> json) => _$EventNoticeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventNoticeResponseToJson(this);
}
