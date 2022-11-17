import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMeetingScreen extends StatefulWidget {
  const NewMeetingScreen({Key? key}) : super(key: key);

  @override
  State<NewMeetingScreen> createState() => _NewMeetingScreenState();
}

class _NewMeetingScreenState extends State<NewMeetingScreen> {
  TextEditingController meetingCodeTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    child: const Icon(Icons.arrow_back_ios_new_sharp, size: 30),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 50),
              Image.network(
                "https://user-images.githubusercontent.com/67534990/127776392-8ef4de2d-2fd8-4b5a-b98b-ea343b19c03e.png",
                fit: BoxFit.cover,
                height: 100,
              ),

              const SizedBox(height: 20),

              const Text(
                "Your meeting is ready",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                child: Card(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: meetingCodeTextEditingController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Example : abc-efg-dhi"
                    ),
                  ),
                ),
              ),

              const Divider(thickness: 1, height: 40, indent: 20, endIndent: 20),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //Share.share("Meeting Code : $_meetingCode");
                    },
                    icon: const Icon(Icons.arrow_drop_down,size: 28,),
                    label: const Text("Share invite",style: TextStyle(fontSize: 17),),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(350, 30),
                      primary: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      //Get.to(VideoCall(channelName: _meetingCode.trim()));
                    },
                    icon: const Icon(Icons.video_call,size: 25,),
                    label: const Text("Start Call",style: TextStyle(fontSize: 17),),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.indigo,
                      side: const BorderSide(color: Colors.indigo),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
