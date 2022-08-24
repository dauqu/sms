import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/dashboard.dart';
import 'package:sms/components/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    var isloading = false;
  // ignore: prefer_typing_uninitialized_variables
  var res;
  late SharedPreferences prefs;

  //Text Field Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future Login() async {
    try {
      final response = await http.post(
          Uri.parse("https://sms.dauqu.com/api/v1/login"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email": _emailController.text,
            "password": _passwordController.text
          }));
      setState(() {
        res = json.decode(response.body);
        print(response.body);
      });

      if (response.statusCode == 200) {
        //Save response OTP to shared preferences
        prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setBool('isLoggedIn', true);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'].toString()),
            duration: const Duration(seconds: 2),
          ),
        );

        //Navigate to login page after 3 seconds
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
          );
        });

        isloading = false;
      } else {
        setState(() {
          // message = res['message'].toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'].toString()),
              duration: const Duration(seconds: 3),
            ),
          );
          isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
        isloading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                // margin: const EdgeInsets.all(10.0),

                //Border Radius
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    //First Text
                    // const Text(
                    //   'Active Kidney',
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),

                    Lottie.network(
                        'https://assets10.lottiefiles.com/packages/lf20_cgjrfdzx.json',
                        height: 150,
                        width: 150,
                        repeat: true),
                    //SizedBox
                    const SizedBox(
                      height: 40,
                    ),

                    //TextField
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: _emailController,
                              onChanged: (value) {
                                //Set shared preferences
                                // setState(() {
                                //   prefs.setString('full_name', value);
                                // });
                              },
                              // controller: full_name,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        )),

                    //SizedBox
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: _passwordController,
                              obscuringCharacter: "#",
                              obscureText: true,
                              // controller: username,
                              onChanged: (value) {
                                //Set shared preferences
                                // setState(() {
                                //   prefs.setString('username', value);
                                // });
                              },
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.security,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 30,
                    ),

                    //Button
                    SizedBox(
                      width: 200.0,
                      height: 35,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xFF4C96F7),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isloading = true;
                          });
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              isloading = false;
                            });
                            Login();
                          });
                        },
                        child: isloading == true
                            ? const SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // Divider
                    Container(
                      alignment: Alignment.center,
                      transformAlignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: const Text(
                          "Have no account? Register",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
    );
  }
}
