import 'dart:async';
import 'dart:io';
import 'package:app/our_services/visa_invitation/join_with_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'new_meeting_screen.dart';

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({Key? key}) : super(key: key);

  @override
  State<TextRecognitionScreen> createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  bool textScanning = false;
  String? extractText;
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Conference"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const NewMeetingScreen()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("New Meeting"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),

              const Divider(
                thickness: 1,
                height: 40,
              ),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const JoinWithCodeScreen()));
                  },

                  icon: const Icon(Icons.margin),
                  label: const Text("Join with a code"),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.indigo,
                    side: const BorderSide(color: Colors.indigo),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Image.network(
                  "https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png"
              )
          ]
          ),
        ),
      ),
    );
  }
}
