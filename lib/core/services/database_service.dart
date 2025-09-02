import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/menu_item_model.dart';
import '../../models/order_model.dart';
import '../../models/kot_model.dart';
import '../../models/user_model.dart';
import '../../models/payment_model.dart';
import 'supabase_service.dart';

class DatabaseService {
  final SupabaseClient _client = SupabaseService().client;

  // Menu Items
  Stream<List<MenuItemModel>> getMenuItems() {
    return _client
        .from('menu_items')
        .stream(primaryKey: ['id'])
        .eq('is_available', true)
        .order('category')
        .map((data) => data
            .map((item) => MenuItemModel.fromMap(item))
            .toList());
  }

  Future<void> addMenuItem(MenuItemModel menuItem) async {
    await _client
        .from('menu_items')
        .insert(menuItem.toMap());
  }

  Future<void> updateMenuItem(MenuItemModel menuItem) async {
    await _client
        .from('menu_items')
        .update(menuItem.toMap())
        .eq('id', menuItem.id);
  }

  Future<void> deleteMenuItem(String id) async {
    await _client
        .from('menu_items')
        .delete()
        .eq('id', id);
  }

  // Orders
  Future<String> createOrder(OrderModel order) async {
    final response = await _client
        .from('orders')
        .insert(order.toMap())
        .select();
    
    return response[0]['id'] as String;
  }

  Stream<List<OrderModel>> getTodaysOrders() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .gte('created_at', startOfDay.toIso8601String())
        .order('created_at', ascending: false)
        .map((data) => data
            .map((order) => OrderModel.fromMap(order))
            .toList());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _client
        .from('orders')
        .update({'status': status})
        .eq('id', orderId);
  }

  // KOTs
  Future<void> createKOT(KOTModel kot) async {
    await _client
        .from('kots')
        .insert(kot.toMap());
  }

  Stream<List<KOTModel>> getActiveKOTs(String? station) {
    var query = _client
        .from('kots')
        .stream(primaryKey: ['id'])
        .inFilter('status', ['newOrder', 'preparing'])
        .order('created_at');

    if (station != null) {
      query = query.eq('station', station);
    }

    return query.map((data) => data
        .map((kot) => KOTModel.fromMap(kot))
        .toList());
  }

  Future<void> updateKOTStatus(String kotId, String status) async {
    final updateData = {'status': status};
    
    if (status == 'preparing') {
      updateData['started_at'] = DateTime.now().toIso8601String();
    } else if (status == 'ready') {
      updateData['completed_at'] = DateTime.now().toIso8601String();
    }

    await _client
        .from('kots')
        .update(updateData)
        .eq('id', kotId);
  }

  // Users
  Future<void> createUser(UserModel user) async {
    await _client
        .from('users')
        .insert(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .single();
    
    if (response != null) {
      return UserModel.fromMap(response);
    }
    return null;
  }

  Stream<List<UserModel>> getUsers() {
    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) => data
            .map((user) => UserModel.fromMap(user))
            .toList());
  }

  Future<void> updateUser(UserModel user) async {
    await _client
        .from('users')
        .update(user.toMap())
        .eq('id', user.id);
  }

  // Reports
  Future<List<Map<String, dynamic>>> getSalesReport(DateTime startDate, DateTime endDate) async {
    final response = await _client
        .from('orders')
        .select()
        .gte('created_at', startDate.toIso8601String())
        .lte('created_at', endDate.toIso8601String())
        .order('created_at');
    
    return List<Map<String, dynamic>>.from(response);
  }

  // Audit Trail
  Future<void> addAuditLog(Map<String, dynamic> auditData) async {
    await _client
        .from('audit_trail')
        .insert({
      ...auditData,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Map<String, dynamic>>> getAuditLogs() {
    return _client
        .from('audit_trail')
        .stream(primaryKey: ['id'])
        .order('timestamp', ascending: false)
        .map((data) => data);
  }
}