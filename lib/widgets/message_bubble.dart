import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    this.profileImageUrl,
    required this.message,
    required this.date

  }) : super(key: key);

  final String? profileImageUrl;
  final String message;
  final String date;

  @override
  Widget build(BuildContext context) {
    final isReceiver = profileImageUrl != null;
    return Row(
      mainAxisAlignment: isReceiver ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(isReceiver)
          Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.grey[200],
              foregroundImage: NetworkImage(profileImageUrl!),
            ),
          ),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: isReceiver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                // profile image
                // Messages
                Container(
                  padding: const EdgeInsets.all(15),
                  constraints: const BoxConstraints(maxWidth: 275),
                  decoration: BoxDecoration(
                    color: isReceiver ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),

                ),

                const SizedBox(height: 8,),

                // Date
                Text(
                  date,
                  style: const TextStyle(fontSize: 12),

                )

              ],
            ),
          ),
        )
      ],
    );
  }
}
