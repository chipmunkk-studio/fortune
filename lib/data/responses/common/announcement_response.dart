import 'package:foresh_flutter/domain/entities/common/announcement_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'announcement_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class AnnouncementResponse extends AnnouncementEntity {
  @JsonKey(name: 'notices')
  final List<Notice>? notices_;

  AnnouncementResponse({
    this.notices_,
  }) : super(
          notices: notices_
                  ?.map(
                    (e) => NoticeEntity(
                      title: e.title ?? "",
                      content: e.content ?? "",
                      createdAt: e.createdAt ?? "",
                      isNew: e.isNew ?? false,
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) => _$AnnouncementResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class Notice {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'content')
  final String? content;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'new')
  final bool? isNew;

  Notice({
    this.title,
    this.content,
    this.createdAt,
    this.isNew,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
