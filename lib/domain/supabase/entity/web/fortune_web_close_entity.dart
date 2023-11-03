import 'package:fortune/domain/supabase/entity/web/fortune_web_common_entity.dart';
import 'package:fortune/presentation-web/fortune_web_ext.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_web_close_entity.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneWebCloseEntity extends FortuneWebCommonEntity {
  final String sample;

  FortuneWebCloseEntity({
    required super.command,
    required this.sample,
  });

  factory FortuneWebCloseEntity.fromJson(Map<String, dynamic> json) => _$FortuneWebCloseEntityFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FortuneWebCloseEntityToJson(this);
}
