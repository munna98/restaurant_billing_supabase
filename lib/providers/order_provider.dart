import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/services/database_service.dart';
import '../core/services/notification_service.dart';
import '../models/order_model.dart';
import '../models/menu_item_model.dart';
import '../models/kot_model.dart';

class OrderProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<OrderItem> _currentOrderItems = [];
  OrderType _orderType = OrderType.dineIn;
  String? _customerName;
  String? _customerPhone;
  String? _tableNumber;
  double _discount = 0;
  bool _isLoading = false;
  String? _error;

  List<OrderItem> get currentOrderItems => _currentOrderItems;
  OrderType get orderType => _orderType;
  String? get customerName => _customerName;
  String? get customerPhone => _customerPhone;
  String? get tableNumber => _tableNumber;
  double get discount => _discount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get subtotal => _currentOrderItems.fold(
      0, (sum, item) => sum + (item.price * item.quantity));
  
  double get tax => subtotal * 0.18; // 18% GST
  double get total => subtotal + tax - _discount;

  void addToOrder(MenuItemModel menuItem, {String? specialInstructions}) {
    final existingIndex = _currentOrderItems.indexWhere(
      (item) => item.menuItemId == menuItem.id && 
                item.specialInstructions == specialInstructions,
    );

    if (existingIndex >= 0) {
      _currentOrderItems[existingIndex] = OrderItem(
        menuItemId: menuItem.id,
        name: menuItem.name,
        price: menuItem.price,
        quantity: _currentOrderItems[existingIndex].quantity + 1,
        specialInstructions: specialInstructions,
        stations: menuItem.stations,
      );
    } else {
      _currentOrderItems.add(OrderItem(
        menuItemId: menuItem.id,
        name: menuItem.name,
        price: menuItem.price,
        quantity: 1,
        specialInstructions: specialInstructions,
        stations: menuItem.stations,
      ));
    }
    notifyListeners();
  }

  void removeFromOrder(int index) {
    if (index < _currentOrderItems.length) {
      _currentOrderItems.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (index < _currentOrderItems.length && newQuantity > 0) {
      final item = _currentOrderItems[index];
      _currentOrderItems[index] = OrderItem(
        menuItemId: item.menuItemId,
        name: item.name,
        price: item.price,
        quantity: newQuantity,
        specialInstructions: item.specialInstructions,
        stations: item.stations,
      );
      notifyListeners();
    } else if (newQuantity <= 0) {
      removeFromOrder(index);
    }
  }

  void setOrderType(OrderType type) {
    _orderType = type;
    notifyListeners();
  }

  void setCustomerDetails({
    String? name,
    String? phone,
    String? table,
  }) {
    _customerName = name;
    _customerPhone = phone;
    _tableNumber = table;
    notifyListeners();
  }

  void setDiscount(double discountAmount) {
    _discount = discountAmount;
    notifyListeners();
  }

  Future<String?> createOrder(String createdBy) async {
    if (_currentOrderItems.isEmpty) return null;

    try {
      _isLoading = true;
      notifyListeners();

      final orderId = const Uuid().v4();
      final orderNumber = 'ORD${DateTime.now().millisecondsSinceEpoch}';

      final order = OrderModel(
        id: orderId,
        orderNumber: orderNumber,
        orderType: _orderType,
        items: _currentOrderItems,
        subtotal: subtotal,
        discount: _discount,
        tax: tax,
        total: total,
        status: OrderStatus.pending,
        customerName: _customerName,
        customerPhone: _customerPhone,
        tableNumber: _tableNumber,
        createdBy: createdBy,
        createdAt: DateTime.now(),
      );

      await _databaseService.createOrder(order);
      await _createKOTs(order);
      
      // Send notification
      await NotificationService.showOrderNotification(orderNumber);

      // Clear current order
      clearOrder();
      
      return orderId;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _createKOTs(OrderModel order) async {
    // Group items by station
    Map<String, List<OrderItem>> stationItems = {};
    
    for (final item in order.items) {
      for (final station in item.stations) {
        stationItems[station] ??= [];
        stationItems[station]!.add(item);
      }
    }

    // Create KOT for each station
    for (final entry in stationItems.entries) {
      final kotId = const Uuid().v4();
      final kot = KOTModel(
        id: kotId,
        orderId: order.id,
        orderNumber: order.orderNumber,
        station: entry.key,
        items: entry.value.map((orderItem) => KOTItem(
          menuItemId: orderItem.menuItemId,
          name: orderItem.name,
          quantity: orderItem.quantity,
          specialInstructions: orderItem.specialInstructions,
          status: KOTItemStatus.pending,
        )).toList(),
        status: KOTStatus.newOrder,
        createdAt: DateTime.now(),
      );

      await _databaseService.createKOT(kot);
      
      // Send notification for each KOT
      await NotificationService.showKOTNotification(kotId, entry.key);
    }
  }

  void clearOrder() {
    _currentOrderItems.clear();
    _customerName = null;
    _customerPhone = null;
    _tableNumber = null;
    _discount = 0;
    notifyListeners();
  }
}