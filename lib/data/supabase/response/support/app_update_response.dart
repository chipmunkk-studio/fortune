import 'package:fortune/domain/supabase/entity/support/app_update_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_update_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class AppUpdateResponse extends AppUpdateEntity {
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'content')
  final String? content_;
  @JsonKey(name: 'is_active')
  final bool? isActive_;
  @JsonKey(name: 'android')
  final bool? android_;

  @JsonKey(name: 'ios')
  final bool? ios_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  AppUpdateResponse({
    this.title_,
    this.content_,
    this.isActive_,
    this.android_,
    this.ios_,
    this.createdAt_,
  }) : super(
          title: title_ ?? '',
          content: content_ ?? '',
          isActive: isActive_ ?? false,
          android: android_ ?? true,
          ios: ios_ ?? true,
          createdAt: createdAt_ ?? '',
        );

  factory AppUpdateResponse.fromJson(Map<String, dynamic> json) => _$AppUpdateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppUpdateResponseToJson(this);
}
