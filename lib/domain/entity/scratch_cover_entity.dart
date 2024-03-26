
class ScratchCoverEntity {
  final String title;
  final String description;
  final String imageUrl;

  ScratchCoverEntity({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory ScratchCoverEntity.initial() => ScratchCoverEntity(
        title: '',
        description: '',
        imageUrl: '',
      );
}
