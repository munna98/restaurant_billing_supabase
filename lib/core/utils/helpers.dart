import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount);
  }

  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatTime(DateTime time, {String format = 'hh:mm a'}) {
    return DateFormat(format).format(time);
  }

  static String generateOrderNumber() {
    final now = DateTime.now();
    return 'ORD${now.millisecondsSinceEpoch}';
  }

  static String generateKOTNumber() {
    final now = DateTime.now();
    return 'KOT${now.millisecondsSinceEpoch}';
  }

  static double calculateTax(double subtotal, {double taxRate = 0.18}) {
    return subtotal * taxRate;
  }

  static double calculateTotal(double subtotal, double discount, double tax) {
    return subtotal + tax - discount;
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}