import 'package:app/our_services/doctor_live_consultation/video_call_screen.dart';
import 'package:app/widgets/message_bubble.dart';
import 'package:app/widgets/message_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageBubble> _messages = [
    MessageBubble(profileImageUrl: "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg?w=2000",
        message: "Hello, Tell me your sickness", date: "Oct 24, 8:59 PM"),

    MessageBubble(message: "Hello, I have been diagnosed with leprosis", date: "Oct 24,9:01 PM"),

    MessageBubble(profileImageUrl: "https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg?w=2000",
        message: "Let me check your previous reports", date: "Oct 24,9:03 PM"),

    MessageBubble(message: "Sure", date: "Oct 24,9:04 PM"),

    MessageBubble(message: "I will get back to you once I check your reports", date: "Oct 24,9:05 PM"),

    MessageBubble(message: "Thanks", date: "Oct 24,9:05 PM"),
  ];

  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Chat",
          style: GoogleFonts.montserrat(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCallScreen()));
                },
                icon: const Icon(Icons.video_camera_front,color: Colors.black,)
            )
          ]
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, index) => _messages[index],
              separatorBuilder: (_, index) => const SizedBox(height: 16),

            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchTextEditingController,
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


        ],
      )


    );
  }
}


