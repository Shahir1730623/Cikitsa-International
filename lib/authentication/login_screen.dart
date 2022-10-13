import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneTextEditingController = TextEditingController();

  List<String> countryTypeList = ["Bangladesh", "India"];
  String? selectedCountry;
  String? selectedCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    phoneTextEditingController.addListener(() => setState(() {}) );
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),

              Image.asset(
                "assets/Logo.png",
                height: height * 0.10,
              ),

              const SizedBox(
                height: 50 ,
              ),

              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    // Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: const [
                            Text(
                              "Let us Take",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Care",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Enter your Phone number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 20,),

                            Text(
                              "CI will need to verify your",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),

                            Text(
                              "Phone Number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),

                          ],
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 30 ,
                    ),

                    DropdownButton(
                      iconSize: 26,
                      dropdownColor: Colors.white,
                      hint: const Text(
                        "Please select your country",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      value: selectedCountry,
                      onChanged: (newValue)
                      {
                        setState(() {
                          selectedCountry = newValue.toString();
                        });
                      },

                      items: countryTypeList.map((country){
                        return DropdownMenuItem(
                          child: Text(
                            country,
                            style: const TextStyle(color: Colors.black),
                          ),
                          value: country,
                        );
                      }).toList(),
                    ),

                    const SizedBox(
                      height: 20 ,
                    ),
                    
                    Row(
                      children: [
                        SizedBox(
                          width: 70,
                            child: TextFormField(
                              readOnly: true,

                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),

                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15
                                ),

                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15
                                ),
                              ),

                            ),
                        ),

                        SizedBox(width: 10,),
                        Expanded(
                          child: TextFormField(
                            controller: phoneTextEditingController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              hintText: "Phone Number",

                              prefixIcon: Icon(Icons.phone),
                              suffixIcon: phoneTextEditingController.text.isEmpty ?
                              Container(width: 0) :
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => phoneTextEditingController.clear(),
                              ),

                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),

                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15
                              ),

                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              ),
                            ),

                            validator: (value){
                              if(value!.isEmpty){
                                return "The field is empty";
                              }

                              else if (value.length >= 10 && value.length < 12) {
                                return "Invalid Phone Number";
                              }

                              else {
                                return null;
                              }
                            },

                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
