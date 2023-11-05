import 'package:json_annotation/json_annotation.dart';

import 'fortune_web_command.dart';

part 'fortune_web_command_close.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneWebCommandClose extends FortuneWebCommand {
  final String sample;

  FortuneWebCommandClose({
    super.command = WebCommand.close,
    required this.sample,
  });

  factory FortuneWebCommandClose.fromJson(Map<String, dynamic> json) => _$FortuneWebCommandCloseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FortuneWebCommandCloseToJson(this);
}
