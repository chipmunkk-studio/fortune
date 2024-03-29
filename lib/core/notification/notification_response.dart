import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneNotificationResponse extends FortuneNotificationEntity {
  @JsonKey(name: 'landing_route')
  final String? landingRoute_;
  @JsonKey(name: 'search_text')
  final String? searchText_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  FortuneNotificationResponse({
    required this.createdAt_,
    required this.searchText_,
    required this.landingRoute_,
  }) : super(
          searchText: searchText_ ?? '',
          landingRoute: landingRoute_ ?? '',
          createdAt: createdAt_ ?? '',
        );

  factory FortuneNotificationResponse.empty() => FortuneNotificationResponse(
        createdAt_: '',
        searchText_: '',
        landingRoute_: '',
      );

  factory FortuneNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$FortuneNotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneNotificationResponseToJson(this);
}

class FortuneNotificationEntity {
  final String landingRoute;
  final String searchText;
  final String createdAt;

  FortuneNotificationEntity({
    required this.createdAt,
    required this.searchText,
    required this.landingRoute,
  });
}
