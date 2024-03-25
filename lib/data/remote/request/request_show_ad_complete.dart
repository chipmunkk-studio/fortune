import 'package:json_annotation/json_annotation.dart';

part 'request_show_ad_complete.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestShowAdComplete {
  @JsonKey(name: 'ts')
  final int ts;

  RequestShowAdComplete({
    required this.ts,
  });

  factory RequestShowAdComplete.fromJson(Map<String, dynamic> json) => _$RequestShowAdCompleteFromJson(json);

  Map<String, dynamic> toJson() => _$RequestShowAdCompleteToJson(this);
}
