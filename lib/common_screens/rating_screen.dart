import 'package:app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class ConsultantRatingScreen extends StatefulWidget {
  const ConsultantRatingScreen({Key? key}) : super(key: key);

  @override
  State<ConsultantRatingScreen> createState() => _ConsultantRatingScreenState();
}

class _ConsultantRatingScreenState extends State<ConsultantRatingScreen> {
  double countRatingStars = 0.0;
  String titleStarsRating = "";

  void saveRatingToDatabase(){
    DatabaseReference reference =  FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!).child(selectedServiceDatabaseParentName!).child(consultationId!).child("rating");

    reference.once().then((dataSnap)
    {
      DataSnapshot snapshot = dataSnap.snapshot;
      if(snapshot.value == null)
      {
        reference.set(countRatingStars.toString());
      }
      else
      {
        double pastRatings = double.parse(snapshot.value.toString());
        double newAverageRatings = (pastRatings + countRatingStars) / 2;
        reference.set(newAverageRatings.toString());
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          (selectedService == "CI Consultation")? "Rate Consultant": "Rate Doctor",
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black
          ),
        ),

        leadingWidth: 75, // Keeps skip button in single line

        leading: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/main_screen");
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.white
          ),
          child: const Text(
            "Skip",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.redAccent
            ),
          ),
        ),
      ),

      backgroundColor: Colors.white,

      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5.0,),

              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                child: Image.asset(
                  "assets/doctorImages/doctor-1.png",
                ),
              ),

              const SizedBox(height: 20.0,),

              // Driver Name
              Text(
                "Dr. Ventakesh Kumar",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 15.0,),

              const Text(
                "Your feedback will help us to provide\nyou with the best service",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 10.0,),

              SmoothStarRating(
                rating: countRatingStars,
                allowHalfRating: false,
                starCount: 5,
                color: Colors.orange,
                borderColor: Colors.orange,
                size: 40,
                onRatingChanged: (starsChosen)
                {
                  countRatingStars = starsChosen;

                  if(countRatingStars == 1)
                  {
                    setState(() {
                      titleStarsRating = "Very Bad";
                    });
                  }
                  if(countRatingStars == 2)
                  {
                    setState(() {
                      titleStarsRating = "Bad";
                    });
                  }
                  if(countRatingStars == 3)
                  {
                    setState(() {
                      titleStarsRating = "Good";
                    });
                  }
                  if(countRatingStars == 4)
                  {
                    setState(() {
                      titleStarsRating = "Very Good";
                    });
                  }
                  if(countRatingStars == 5)
                  {
                    setState(() {
                      titleStarsRating = "Excellent";
                    });
                  }
                },
              ),

              const SizedBox(height: 10.0,),

              Text(
                titleStarsRating,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 15.0,),

              ElevatedButton(
                  onPressed: ()
                  {
                    saveRatingToDatabase();
                  },

                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 74),
                  ),

                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
              ),

              const SizedBox(height: 10.0,),

            ],
          ),
        ),
      ),
    );
  }
}
