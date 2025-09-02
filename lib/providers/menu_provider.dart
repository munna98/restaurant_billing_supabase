import 'package:flutter/material.dart';
import '../core/services/database_service.dart';
import '../models/menu_item_model.dart';

class MenuProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<MenuItemModel> _menuItems = [];
  bool _isLoading = false;
  String? _error;

  List<MenuItemModel> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get categories {
    return _menuItems.map((item) => item.category).toSet().toList();
  }

  void loadMenuItems() {
    _isLoading = true;
    notifyListeners();

    _databaseService.getMenuItems().listen((items) {
      _menuItems = items;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  List<MenuItemModel> getMenuItemsByCategory(String category) {
    if (category == 'All') return _menuItems;
    return _menuItems.where((item) => item.category == category).toList();
  }

  Future<void> addMenuItem(MenuItemModel menuItem) async {
    try {
      await _databaseService.addMenuItem(menuItem);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMenuItem(MenuItemModel menuItem) async {
    try {
      await _databaseService.updateMenuItem(menuItem);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMenuItem(String id) async {
    try {
      await _databaseService.deleteMenuItem(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}