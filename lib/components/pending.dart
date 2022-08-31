import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sms/components/failed.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  Duration duration = const Duration(seconds: 300);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void addTime() {
    const addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds - addSeconds;

      if (seconds <= 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Failed(),
          ),
        );
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());

    setState(() {
      duration = duration;
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

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
            children: [
              const Text(
                  'Payment Pending, Please wait for the confirmation, Thank you',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 50,
              ),

              //CountDownTimer
              // Text(duration.toString().split('.').first.padLeft(8, '0'),
              //     style: const TextStyle(
              //         fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Text(duration.toString().split('.').first.toString(),
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
