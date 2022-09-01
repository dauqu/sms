import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/app_icon');

    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body, int seconds) async {
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'Zoom Plus Meeting',
    //       'Zoom Plus Meeting',
    //       // 'Main channel notifications',
    //       importance: Importance.max,
    //       priority: Priority.max,
    //       icon: '@drawable/app_icon'
    //     ),
    //     // iOS: IOSNotificationDetails(
    //     //   // sound: 'default.wav',
    //     //   presentAlert: true,
    //     //   presentBadge: true,
    //     //   presentSound: true,
    //     // ),
    //   ),
    //   uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //   androidAllowWhileIdle: true,
    // );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ghfgh',
          'gfhfgh',
          // 'Main channel notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@drawable/app_icon',
          ongoing: true,
        ),
      ),
    );
  }
}