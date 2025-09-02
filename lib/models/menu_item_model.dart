class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String? imageUrl;
  final bool isAvailable;
  final List<String> stations;
  final int preparationTime;
  final DateTime createdAt;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    this.isAvailable = true,
    required this.stations,
    this.preparationTime = 15,
    required this.createdAt,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      imageUrl: map['image_url'],
      isAvailable: map['is_available'] ?? true,
      stations: List<String>.from(map['stations'] ?? []),
      preparationTime: map['preparation_time'] ?? 15,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'stations': stations,
      'preparation_time': preparationTime,
      'created_at': createdAt.toIso8601String(),
    };
  }
}