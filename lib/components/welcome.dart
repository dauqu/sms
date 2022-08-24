import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sms/components/dashboard.dart';
import 'package:sms/components/login.dart';
import 'package:sms/components/register.dart';

import 'package:http/http.dart' as http;
import 'package:sms/components/dashboard.dart';
import 'package:sms/components/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late SharedPreferences prefs;
  bool isLogin = false;
  bool isloading = false;
  var res_var;
  var error_var;

  //Check if user is logged i
  Future getProfile() async {
    setState(() {
      isloading = true;
    });

    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
        Uri.parse("https://sms.dauqu.com/api/v1/login/isLoggedIn"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "token": prefs.getString('token').toString(),
        }));
         print(jsonDecode(response.body));
    setState(() {
      res_var = json.decode(response.body);
    });
    if (response.statusCode == 200) {
      if (res_var == true) {
        print(res_var);
      }
      isloading = false;
    } else {
      setState(() {
        // message = res['message'].toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res_var),
            duration: const Duration(seconds: 3),
          ),
        );
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Start A Meeting",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please enter the room code to continue",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/meeting.png",
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Dashboard(),
                  //   ),
                  // );
                  getProfile();
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.shade800),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                ),
                child: const Text('Join a Meeting',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                    child: const Text('Login',
                        style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text('Register',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
