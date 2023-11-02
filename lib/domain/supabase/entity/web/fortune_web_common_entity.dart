import 'package:json_annotation/json_annotation.dart';

part 'fortune_web_common_entity.g.dart';

const fortuneWebChannel = "fortuneWebChannel";

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class FortuneWebCommonEntity {
  @JsonKey(name: 'command')
  final WebCommand? command;

  FortuneWebCommonEntity({
    required this.command,
  });

  factory FortuneWebCommonEntity.fromJson(Map<String, dynamic> json) => _$FortuneWebCommonEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneWebCommonEntityToJson(this);
}

extension WebCommandParser on String {
  WebCommand toWebCommand() {
    for (WebCommand command in WebCommand.values) {
      if (this == command.name) {
        return command;
      }
    }
    throw Exception('Unknown command: $this');
  }
}

enum WebCommand {
  close,
}
