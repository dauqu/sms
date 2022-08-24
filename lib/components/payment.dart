import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _caredController = TextEditingController();
  final TextEditingController _exController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  var res;
  bool _isLoading = false;

  Future SaveData() async {
    final prefs = await SharedPreferences.getInstance();
    // var code = prefs.getString('code');
    // var name = prefs.getString('name');

    try {
      final response =
          await http.post(Uri.parse("https://sms.dauqu.com/api/v1/card"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "amount": _amountController.text,
                "fname": _fnameController.text,
                "phone": _phoneController.text,
                "card_number": _caredController.text,
                "expiry_date": _exController.text,
                "cvv": _cvvController.text,
              }));
      setState(() {
        res = json.decode(response.body);
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        _isLoading = false;
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
          _isLoading = false;
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
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error" + e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
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
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                //Border Radius Color
                side: BorderSide(color: Colors.blue.shade800),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.security, color: Colors.green.shade800),
                        Text(
                          'Secure Payment',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Extra 10% off on credit card payment',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        label: Text('Amount *'),
                        isDense: true,
                        hintText: 'xxx.xx',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller: _fnameController,
                      decoration: const InputDecoration(
                        label: Text('Full Name *'),
                        isDense: true,
                        hintText: 'xxxxx xxxxx',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: const InputDecoration(
                        label: Text('Phone Number *'),
                        isDense: true,
                        hintText: '09xxxxxxxxx',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller: _caredController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: const InputDecoration(
                        label: Text('Card Number *'),
                        isDense: true,
                        hintText: 'xxxx-xxxx-xxxx-xxxx',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      readOnly: true,
                      controller: _exController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Expiry Date *',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        //Show date picker
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2029),
                        );

                        if (newDate != null) {
                          setState(() {
                            _exController.text = newDate.toString();
                          });
                        }
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: const InputDecoration(
                        label: Text('CVV *'),
                        isDense: true,
                        hintText: 'xxx',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //Button
                    ElevatedButton(
                      onPressed: () {
                        SaveData();
                        setState(() {
                          _isLoading = true;
                        });
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green.shade800),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 40)),
                      ),
                      // child: const Text('Pay Now',
                      //     style: TextStyle(color: Colors.white)),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                                strokeWidth: 5,
                              ),
                            )
                          : const Text('Pay Now',
                              style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
