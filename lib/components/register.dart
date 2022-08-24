import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sms/components/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var isloading = false;
  // ignore: prefer_typing_uninitialized_variables
  var res;
  late SharedPreferences prefs;

  //Text Field Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ignore: non_constant_identifier_names
  Future Register() async {
    try {
      final response = await http.post(
          Uri.parse("https://sms.dauqu.com/api/v1/register"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "full_name": _nameController.text,
            "username": _usernameController.text,
            "phone": _phoneController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
          }));
      setState(() {
        res = json.decode(response.body);
      });

      if (response.statusCode == 200) {
        //Save response OTP to shared preferences
        prefs = await SharedPreferences.getInstance();

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'].toString()),
            duration: const Duration(seconds: 2),
          ),
        );

        //Navigate to login page after 3 seconds
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
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
        // error = e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
        isloading = false;

        //Redirect to OTP page
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Colors.blue.shade800.value),
          title: const Text('Register'),
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
                              controller: _nameController,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                hintText: 'Full name',
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
                              controller: _usernameController,
                              // controller: full_name,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.tag,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                hintText: 'Username',
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
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        )),

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
                              controller: _emailController,
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
                      height: 20,
                    ),

                    //Button
                    SizedBox(
                      width: 200.0,
                      height: 35.0,
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
                            Register();
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
                                'Create Account',
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
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
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
      ),
    );
  }
}
