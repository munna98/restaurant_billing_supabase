class AppConstants {
  static const String appName = 'Restaurant Billing App';
  static const String appVersion = '1.0.0';
  
  // Order types
  static const List<String> orderTypes = ['Dine In', 'Take Out', 'Delivery'];
  
  // Order statuses
  static const List<String> orderStatuses = [
    'Pending',
    'Preparing',
    'Ready',
    'Completed',
    'Cancelled'
  ];
  
  // KOT statuses
  static const List<String> kotStatuses = [
    'New Order',
    'Preparing',
    'Ready',
    'Completed'
  ];
  
  // Payment methods
  static const List<String> paymentMethods = [
    'Cash',
    'Card',
    'UPI',
    'Net Banking'
  ];
  
  // Default categories
  static const List<String> menuCategories = [
    'Starters',
    'Main Course',
    'Desserts',
    'Beverages',
    'Specials'
  ];
  
  // Kitchen stations
  static const List<String> kitchenStations = [
    'Grill',
    'Fryer',
    'Oven',
    'Salad',
    'Bar'
  ];
}