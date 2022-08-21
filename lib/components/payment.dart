import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
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
                        LengthLimitingTextInputFormatter(6),
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
                        // Navigator.pushNamed(context, '/home');
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
                      child: const Text('Pay Now',
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
