import 'package:flutter/material.dart';
import '../core/services/database_service.dart';
import '../models/kot_model.dart';

class KOTProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<KOTModel> _activeKOTs = [];
  bool _isLoading = false;
  String? _error;

  List<KOTModel> get activeKOTs => _activeKOTs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadActiveKOTs(String? station) {
    _isLoading = true;
    notifyListeners();

    _databaseService.getActiveKOTs(station).listen((kots) {
      _activeKOTs = kots;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> updateKOTStatus(String kotId, String status) async {
    try {
      await _databaseService.updateKOTStatus(kotId, status);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}