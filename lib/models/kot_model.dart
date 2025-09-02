class KOTModel {
  final String id;
  final String orderId;
  final String orderNumber;
  final String station;
  final List<KOTItem> items;
  final KOTStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? assignedChef;

  KOTModel({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.station,
    required this.items,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.assignedChef,
  });

  factory KOTModel.fromMap(Map<String, dynamic> map) {
    return KOTModel(
      id: map['id'] ?? '',
      orderId: map['order_id'] ?? '',
      orderNumber: map['order_number'] ?? '',
      station: map['station'] ?? '',
      items: List<KOTItem>.from(
        (map['items'] as List<dynamic>? ?? []).map((x) => KOTItem.fromMap(x)),
      ),
      status: KOTStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['status'] ?? '').toLowerCase(),
        orElse: () => KOTStatus.newOrder,
      ),
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      startedAt: map['started_at'] != null ? DateTime.parse(map['started_at']) : null,
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
      assignedChef: map['assigned_chef'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'order_number': orderNumber,
      'station': station,
      'items': items.map((x) => x.toMap()).toList(),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'assigned_chef': assignedChef,
    };
  }
}

class KOTItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final String? specialInstructions;
  final KOTItemStatus status;

  KOTItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    this.specialInstructions,
    required this.status,
  });

  factory KOTItem.fromMap(Map<String, dynamic> map) {
    return KOTItem(
      menuItemId: map['menuItemId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      specialInstructions: map['specialInstructions'],
      status: KOTItemStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['status'] ?? '').toLowerCase(),
        orElse: () => KOTItemStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'status': status.name,
    };
  }
}

enum KOTStatus { newOrder, preparing, ready, completed }
enum KOTItemStatus { pending, preparing, ready, cancelled }