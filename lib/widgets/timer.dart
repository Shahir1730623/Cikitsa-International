import 'dart:async';
import 'package:app/global/global.dart';
import 'package:app/our_services/doctor_live_consultation/chat_screen.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen.dart';
import 'package:app/our_services/doctor_live_consultation/uploading_prescription.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main_screen.dart';

class TimerController extends GetxController{
  Timer? _timer;
  int remainingSeconds = 1;
  final time = '00.00'.obs;
  static BuildContext? context;
  int countDownSeconds = 30;

  @override
  void onReady(){
    _startTimer(countDownSeconds);
    super.onReady();
  }

  @override
  void onClose(){
    if(_timer != null){
      _timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds){
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if(remainingSeconds == 0){
        timer.cancel();
        showDialog(
            context: context!,
            barrierDismissible: false,
            builder: (BuildContext context){
              return ProgressDialog(message: "Redirecting to video call...");
            }
        );

        Timer(const Duration(seconds: 5),()  {
          Navigator.pop(context!);
          Navigator.push(context!, MaterialPageRoute(builder: (context) => UploadingPrescription()));

        });

      }

      else{
        int minutes = remainingSeconds~/ 60;
        int seconds = (remainingSeconds % 60);
        time.value = minutes.toString().padLeft(2, "0")+ ":" + seconds.toString().padLeft(2, "0");
        remainingSeconds--;
      }
    });
  }


}