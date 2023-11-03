import 'package:fortune/presentation-web/fortune_web_ext.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_web_common_entity.g.dart';

const fortuneWebChannel = "fortuneWebChannel";

@JsonSerializable(ignoreUnannotated: false)
class FortuneWebCommonEntity {
  @JsonKey(name: 'command')
  final WebCommand? command;

  FortuneWebCommonEntity({
    required this.command,
  });

  factory FortuneWebCommonEntity.fromJson(Map<String, dynamic> json) => _$FortuneWebCommonEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneWebCommonEntityToJson(this);
}

