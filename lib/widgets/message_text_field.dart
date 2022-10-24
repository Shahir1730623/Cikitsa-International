import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.send,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,vertical: 8
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: "Send a message"
          ),



        ),
      ),
    );
  }
}

