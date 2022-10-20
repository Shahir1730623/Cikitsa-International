import 'package:flutter/cupertino.dart';

class OldUserForm extends StatefulWidget {
  const OldUserForm({Key? key}) : super(key: key);

  @override
  State<OldUserForm> createState() => _OldUserFormState();
}

class _OldUserFormState extends State<OldUserForm> {
  TextEditingController problemTextEditingController = TextEditingController();

  List<String> reasonOfVisitTypesList = [
    "Cancer",
    "Heart Problem",
    "Skin problem",
    "Liver problem",
    "Broken bones"
  ];
  String? selectedReasonOfVisit;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Image.asset(
              "assets/Logo.png",
              height: 50,
              width: 50,
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              "Patient Information",
              style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: height * 0.005,
            ),

            const Text(
              "Fill up the required information",
            ),
            SizedBox(height: height * 0.03),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name Field
                  Text(
                    "First Name",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: firstNameTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "First Name",
                      hintText: "First Name",
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          "assets/user.png",
                          height: 18,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: firstNameTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            firstNameTextEditingController.clear(),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The field is empty";
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Last Name Field
                  Text(
                    "Last Name",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: lastNameTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      hintText: "Last Name",
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          "assets/user.png",
                          height: 18,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: lastNameTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            lastNameTextEditingController.clear(),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The field is empty";
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Age Field
                  Text(
                    "Age",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: ageTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Age",
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          "assets/age.png",
                          height: 18,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: ageTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            firstNameTextEditingController.clear(),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The field is empty";
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Height,Weight Fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Weight",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: weightTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Weight",
                                hintText: "Weight",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/weight.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: weightTextEditingController
                                    .text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      weightTextEditingController.clear(),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                } else
                                  return null;
                              },
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: height * 0.005,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Height",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: heightTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Height",
                                hintText: "Height",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/height.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: heightTextEditingController
                                    .text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      heightTextEditingController.clear(),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                } else
                                  return null;
                              },
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Gender,Relation Fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: genderTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Gender",
                                hintText: "Gender",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/gender.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: genderTextEditingController
                                    .text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      genderTextEditingController.clear(),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                } else
                                  return null;
                              },
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: height * 0.005,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Relation",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: relationshipTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Relation",
                                hintText: "Relation",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/relations.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: relationshipTextEditingController
                                    .text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      relationshipTextEditingController
                                          .clear(),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                labelStyle: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                } else
                                  return null;
                              },
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Reason of visit
                  Text(
                    "Reason of visit",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  DropdownButton(
                    isExpanded: true,
                    iconSize: 26,
                    dropdownColor: Colors.white,
                    hint: const Text(
                      "Specify the reason",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    value: selectedReasonOfVisit,
                    onChanged: (newValue) {
                      setState(() {
                        selectedReasonOfVisit = newValue.toString();
                      });
                    },
                    items: reasonOfVisitTypesList.map((reason) {
                      return DropdownMenuItem(
                        value: reason,
                        child: Text(
                          reason,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Describe the problem
                  Text(
                    "Describe the problem",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: problemTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Write here",
                      hintText: "Write here",
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          "assets/edit-info.png",
                          height: 18,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: problemTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            problemTextEditingController.clear(),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The field is empty";
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseUser()));
                            },
                            child: Text(
                              "Existing Patient?\nClick here ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                              ),
                            )
                        ),

                        // Button
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.lightBlue.withOpacity(0.2),
                            ),
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                saveNewUserInfo();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    //border radius equal to or more than 50% of width
                                  )),
                              child: const Icon(Icons.arrow_forward_outlined),
                            ))
                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
