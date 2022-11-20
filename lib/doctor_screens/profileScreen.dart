import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [

              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),

              Positioned(
                top: 20,
                left: 20,
                child: CircleAvatar(
                  child: Icon(Icons.person,color: Colors.white,),
                ),
              ),

              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications,color: Colors.grey,),
                ),
              ),

              Positioned(
                top: 120,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      'Zhafira',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),


                    Text(
                      'Have a nice day',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 20,),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(100, 40),
                      ),
                      onPressed: () {
                      },
                      child: Row(
                        children: [
                          Icon(Icons.doorbell),

                          Text(
                            'Urgent Care',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                )
              )
            ],
          ),

          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Ecare Services',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2,color: Colors.grey),
                          ),
                          child: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Text(
                          'Consultation',
                        )

                      ],
                    ),

                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2,color: Colors.grey),
                          ),
                          child: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Text(
                          'Consultation',
                        )

                      ],
                    ),

                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2,color: Colors.grey),
                          ),
                          child: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Text(
                          'Consultation',
                        )

                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Appointment',
                    ),

                    Text('See All', style: TextStyle(color: Colors.blue,),)
                  ],
                ),

                SizedBox(height: 20,),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            VerticalDivider(color: Colors.blueAccent, thickness: 3,),

                            SizedBox(width: 10,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Appointment Date'),

                                        SizedBox(height: 10,),

                                        Row(
                                          children: [
                                            Icon(Icons.access_time),

                                            SizedBox(width: 10,),

                                            Text('Wed Jun 20 - 8:00 - 8:30 AM',style: TextStyle(color: Colors.grey),),
                                          ],
                                        ),
                                      ],
                                    ),

                                    SizedBox(width: MediaQuery.of(context).size.width-310,),

                                    Icon(Icons.more_vert),

                                  ],
                                ),

                                SizedBox(height: 10,),

                                Container(color: Colors.grey, height: 1, width: MediaQuery.of(context).size.width-80,),

                                SizedBox(height: 10,),

                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage('assets/doctor1.jpg'),
                                    ),

                                    SizedBox(width: 10,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('dr. Rokabuming'),

                                        SizedBox(height: 10,),

                                        Text('Dentist'),
                                      ],
                                    )

                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
