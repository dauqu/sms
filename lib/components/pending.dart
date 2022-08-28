import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Pending'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                  'Payment Pending, Please wait for the confirmation, Thank you',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 20,
              ),
              
              //CountDownTimer
              Text('Time Remaining',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              Text('02:00:00',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red)),
              SizedBox(
                height: 20,
              ), 
            ],
          ),
        ),
      ),
    );
  }
}
