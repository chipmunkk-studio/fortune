import 'package:fortune/domain/supabase/entity/web/fortune_web_common_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_web_close_entity.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class FortuneWebCloseEntity extends FortuneWebCommonEntity {

  FortuneWebCloseEntity({
    required WebCommand? command,
  }) : super(command: command);

  factory FortuneWebCloseEntity.fromJson(Map<String, dynamic> json) => _$FortuneWebCloseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneWebCloseEntityToJson(this);
}