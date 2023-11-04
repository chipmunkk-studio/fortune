import 'package:json_annotation/json_annotation.dart';

part 'fortune_web_query_param.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneWebQueryParam {
  @JsonKey(name: 'testData')
  final String testData;

  FortuneWebQueryParam({
    this.testData = '',
  });

  factory FortuneWebQueryParam.fromJson(Map<String, dynamic> json) => _$FortuneWebQueryParamFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FortuneWebQueryParamToJson(this);
}
