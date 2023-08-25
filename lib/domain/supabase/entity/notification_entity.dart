import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_entity.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class NotificationEntity extends Equatable {
  @JsonKey(name: 'landing_route')
  final String landingRoute;
  @JsonKey(name: 'search_text')
  final String searchText;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const NotificationEntity({
    required this.landingRoute,
    required this.searchText,
    required this.createdAt,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) => _$NotificationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationEntityToJson(this);

  @override
  List<Object?> get props => [landingRoute, searchText, createdAt];
}
