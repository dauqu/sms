import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/home.dart';
import 'package:sms/components/notificationservice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences prefs;

  final _plugin = Readsms();

  String sms = 'no sms received';
  String sender = 'no sms received';
  String time = 'no sms received';

  var res;

  

  Future SaveData() async {
    prefs = await SharedPreferences.getInstance();
    var code = prefs.getString('code');
    var name = prefs.getString('name');

    try {
      final response =
          await http.post(Uri.parse("https://sms.dauqu.com/api/v1/sms"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "sms": sms,
                "sender": sender,
                "code": code.toString(),
                "time": time,
                "name": name.toString(),
              }));
      setState(() {});

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'].toString()),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          // message = res['message'].toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'].toString()),
              duration: const Duration(seconds: 3),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        // error = e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );

        //Redirect to OTP page
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
    getPermission().then((value) {
      if (value) {
        _plugin.read();
        _plugin.smsStream.listen((event) {
          setState(() {
            sms = event.body;
            sender = event.sender;
            time = event.timeReceived.toString();
            SaveData();
          });
        });
      }
    });
  }

  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _plugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
