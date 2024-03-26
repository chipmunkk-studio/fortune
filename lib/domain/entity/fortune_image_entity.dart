import 'package:fortune/data/remote/response/fortune_response_ext.dart';

class FortuneImageEntity {
  final String url;
  final ImageType type;
  final String alt;

  FortuneImageEntity({
    required this.url,
    required this.type,
    required this.alt,
  });

  factory FortuneImageEntity.empty() => FortuneImageEntity(
        url: '',
        type: ImageType.NONE,
        alt: '',
      );
}
