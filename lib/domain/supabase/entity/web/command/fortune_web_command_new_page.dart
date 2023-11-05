import 'package:json_annotation/json_annotation.dart';

import 'fortune_web_command.dart';

part 'fortune_web_command_new_page.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneWebCommandNewPage extends FortuneWebCommand {
  final String url;

  FortuneWebCommandNewPage({
    super.command = WebCommand.newWebPage,
    required this.url,
  });

  factory FortuneWebCommandNewPage.fromJson(Map<String, dynamic> json) => _$FortuneWebCommandNewPageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FortuneWebCommandNewPageToJson(this);
}
