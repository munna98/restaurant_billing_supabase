import 'package:flutter/material.dart';
import '../core/services/database_service.dart';

class ReportProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<Map<String, dynamic>> _salesData = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get salesData => _salesData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSalesReport(DateTime startDate, DateTime endDate) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await _databaseService.getSalesReport(startDate, endDate);
      _salesData = data;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  double get totalSales {
    return _salesData.fold(0, (sum, order) => sum + (order['total'] ?? 0));
  }

  double get averageOrderValue {
    if (_salesData.isEmpty) return 0;
    return totalSales / _salesData.length;
  }

  Map<String, double> get salesByCategory {
    final Map<String, double> categorySales = {};
    
    for (final order in _salesData) {
      final items = order['items'] as List<dynamic>? ?? [];
      for (final item in items) {
        final category = item['category'] ?? 'Unknown';
        final total = (item['price'] ?? 0) * (item['quantity'] ?? 0);
        
        categorySales[category] = (categorySales[category] ?? 0) + total;
      }
    }
    
    return categorySales;
  }
}