class PickedItemEntity {
  final String imageUrl;

  final String name;

  final String description;

  PickedItemEntity({
    required this.imageUrl,
    required this.name,
    required this.description,
  });

  factory PickedItemEntity.initial() => PickedItemEntity(
        imageUrl: '',
        name: '',
        description: '',
      );
}
