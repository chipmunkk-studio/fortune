import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_entity.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class NotificationEntity extends Equatable {
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'landingRoute')
  final String landingRoute;

  const NotificationEntity({
    required this.title,
    required this.content,
    required this.landingRoute,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) => _$NotificationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationEntityToJson(this);

  @override
  List<Object?> get props => [title, content, landingRoute];
}
