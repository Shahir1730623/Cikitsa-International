import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {

  String? message;

  ProgressDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        child: Container(
          height: 100,
          margin: const EdgeInsets.all(16.0),

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0)
          ),

          child: Center(
            child: Row(
              children: [
                const SizedBox(width: 10.0),

                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),

                const SizedBox(width: 30.0),

                Image.asset(
                  'assets/Logo.png',
                  width: 130,
                ),


              ],
            )

          ),


        )
    );
  }
}



