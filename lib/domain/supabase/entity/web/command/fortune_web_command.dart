import 'package:json_annotation/json_annotation.dart';

part 'fortune_web_command.g.dart';

const fortuneWebChannel = "fortuneWebChannel";

@JsonSerializable(ignoreUnannotated: false)
class FortuneWebCommand {
  @JsonKey(name: 'command')
  final WebCommand? command;

  FortuneWebCommand({
    required this.command,
  });

  factory FortuneWebCommand.fromJson(Map<String, dynamic> json) => _$FortuneWebCommandFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneWebCommandToJson(this);
}


enum WebCommand {
  close,
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