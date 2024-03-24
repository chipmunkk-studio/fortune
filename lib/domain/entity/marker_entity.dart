class MarkerEntity {
  final String id;
  final String name;
  final String imageUrl;
  final String itemType;
  final double latitude;
  final double longitude;
  final int cost;

  MarkerEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.itemType,
    required this.latitude,
    required this.longitude,
    required this.cost,
  });
}
