import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'restaurant_channel',
      'Restaurant Notifications',
      channelDescription: 'Notifications for restaurant operations',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> showOrderNotification(String orderNumber) async {
    await showNotification(
      title: 'New Order',
      body: 'Order #$orderNumber has been placed',
    );
  }

  static Future<void> showKOTNotification(String kotNumber, String station) async {
    await showNotification(
      title: 'New KOT for $station',
      body: 'KOT #$kotNumber needs preparation',
    );
  }
}