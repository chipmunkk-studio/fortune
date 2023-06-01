class RecipeEntity {
  final String name;
  final String imageUrl;
  final int targetCount;
  final int userHaveCount;

  RecipeEntity({
    required this.name,
    required this.imageUrl,
    required this.targetCount,
    required this.userHaveCount,
  });
}
