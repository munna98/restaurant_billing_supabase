class OrderModel {
  final String id;
  final String orderNumber;
  final OrderType orderType;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final OrderStatus status;
  final PaymentModel? payment;
  final String? customerName;
  final String? customerPhone;
  final String? tableNumber;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? completedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    required this.items,
    required this.subtotal,
    this.discount = 0,
    required this.tax,
    required this.total,
    required this.status,
    this.payment,
    this.customerName,
    this.customerPhone,
    this.tableNumber,
    required this.createdBy,
    required this.createdAt,
    this.completedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      orderNumber: map['order_number'] ?? '',
      orderType: OrderType.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['order_type'] ?? '').toLowerCase(),
        orElse: () => OrderType.dineIn,
      ),
      items: List<OrderItem>.from(
        (map['items'] as List<dynamic>? ?? []).map((x) => OrderItem.fromMap(x)),
      ),
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['status'] ?? '').toLowerCase(),
        orElse: () => OrderStatus.pending,
      ),
      payment: map['payment'] != null ? PaymentModel.fromMap(map['payment']) : null,
      customerName: map['customer_name'],
      customerPhone: map['customer_phone'],
      tableNumber: map['table_number'],
      createdBy: map['created_by'] ?? '',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'order_type': orderType.name,
      'items': items.map((x) => x.toMap()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'status': status.name,
      'payment': payment?.toMap(),
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'table_number': tableNumber,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String? specialInstructions;
  final List<String> stations;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.specialInstructions,
    required this.stations,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      menuItemId: map['menuItemId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      specialInstructions: map['specialInstructions'],
      stations: List<String>.from(map['stations'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'stations': stations,
    };
  }
}

enum OrderType { dineIn, takeOut, delivery }
enum OrderStatus { pending, preparing, ready, completed, cancelled }