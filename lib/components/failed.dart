import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Failed extends StatefulWidget {
  const Failed({Key? key}) : super(key: key);

  @override
  State<Failed> createState() => _FailedState();
}

class _FailedState extends State<Failed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Text('Failed'),
      ),
      body: Center(
        child: Container(
          width: 350, 
          height: 500,
          padding:
              const EdgeInsets.only(top: 50, bottom: 50, left: 10, right: 10),
          child: Card(
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Rounded components
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Icon(
                      Icons.payment_rounded,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Payment Failed',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Your payment has been declined \n from your bank. Please check \n your online transaction enabled \n or try again.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
