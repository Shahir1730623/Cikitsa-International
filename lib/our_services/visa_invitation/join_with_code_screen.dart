import 'package:app/global/global.dart';
import 'package:app/our_services/visa_invitation/video_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class JoinWithCodeScreen extends StatefulWidget {
  const JoinWithCodeScreen({Key? key}) : super(key: key);

  @override
  State<JoinWithCodeScreen> createState() => _JoinWithCodeScreenState();
}

class _JoinWithCodeScreenState extends State<JoinWithCodeScreen> {

  TextEditingController meetingCodeTextEditingController = TextEditingController();
  bool validateError = false;
  String? role; //no radio button will be selected on initial


  @override
  void dispose() {
    // TODO: implement dispose
    meetingCodeTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                "https://user-images.githubusercontent.com/67534990/127776450-6c7a9470-d4e2-4780-ab10-143f5f86a26e.png",
                fit: BoxFit.cover,
                height: 100,
              ),

              const SizedBox(height: 20),

              const Text(
                "Enter meeting code below",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Card(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: meetingCodeTextEditingController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Example : abc-efg-dhi",
                        errorText: validateError ? "Meeting Code is mandatory" : null
                    ),
                  ),
                ),
              ),

              RadioListTile(
                title: const Text("Host"),
                value: "Host",
                groupValue: role,
                onChanged: (value){
                  setState(() {
                    role = value.toString();
                    tokenRole = 1;
                    Fluttertoast.showToast(msg: tokenRole.toString());
                  });
                },
              ),

              RadioListTile(
                title: const Text("Audience"),
                value: "Audience",
                groupValue: role,
                onChanged: (value){
                  setState(() {
                    role = value.toString();
                    tokenRole = 2;
                    Fluttertoast.showToast(msg: tokenRole.toString());
                  });
                },
              ),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        meetingCodeTextEditingController.text.isEmpty ? validateError = true : validateError = false;
                      });
                      if(meetingCodeTextEditingController.text.isNotEmpty){
                        channelName = meetingCodeTextEditingController.text.trim();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AgoraScreen()));
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text("Join"),
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
