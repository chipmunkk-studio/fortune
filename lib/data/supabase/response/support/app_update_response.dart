import 'package:fortune/domain/supabase/entity/support/app_update_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_update_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class AppUpdateResponse extends AppUpdateEntity {
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'content')
  final String? content_;
  @JsonKey(name: 'landing_route')
  final String? landingRoute_;
  @JsonKey(name: 'is_active')
  final bool? isActive_;
  @JsonKey(name: 'android')
  final bool? android_;
  @JsonKey(name: 'ios')
  final bool? ios_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;
  @JsonKey(name: 'min_version')
  final String? minVersion_;
  @JsonKey(name: 'min_version_code')
  final int? minVersionCode_;
  @JsonKey(name: 'is_alert')
  final bool? isAlert_;

  AppUpdateResponse({
    this.title_,
    this.content_,
    this.isActive_,
    this.minVersion_,
    this.landingRoute_,
    this.minVersionCode_,
    this.isAlert_,
    this.android_,
    this.ios_,
    this.createdAt_,
  }) : super(
          title: title_ ?? '',
          content: content_ ?? '',
          landingRoute: landingRoute_ ?? '',
          isActive: isActive_ ?? false,
          minVersion: minVersion_ ?? '',
          minVersionCode: minVersionCode_ ?? -1,
          isAlert: isAlert_ ?? false,
          android: android_ ?? true,
          ios: ios_ ?? true,
          createdAt: createdAt_ ?? '',
        );

  factory AppUpdateResponse.fromJson(Map<String, dynamic> json) => _$AppUpdateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppUpdateResponseToJson(this);
}
