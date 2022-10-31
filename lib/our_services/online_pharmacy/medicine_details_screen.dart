import 'package:app/our_services/online_pharmacy/checkout_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicineDetailsScreen extends StatefulWidget {
  const MedicineDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {

  // List of items in our dropdown menu
  var itemsTypeList = ['1 pc', '10 pcs', '1 box',];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,size: 25),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
            },
            icon: Icon(Icons.add_shopping_cart),
            color: Colors.black,
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
                'assets/pharmacyImages/Napa.png',
                width: 200,
              )
          ),

          const SizedBox(height: 20,),

          Text(
            'Napa 500 mg',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),

          const SizedBox(height: 10,),

          Text(
            'Tablet',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 20,),

          Text(
            'Paracetamol 500 mg',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 10,),

          Text(
            'Beximco Pharmaceuticals',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 30,),

          // Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                  color: Colors.blueAccent, style: BorderStyle.solid, width: 1),
            ),

            child: DropdownButton(
              hint: const Text(
                "Quantity",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),

              // Initial Value
              value: selectedValue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // populating dropdown with Array list of items
              items: itemsTypeList.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),

              // After selecting the desired option,it will change button value to selected value
              onChanged: (newValue)
              {
                setState(() {
                  selectedValue = newValue.toString();
                });
              },
            ),
          ),

          const SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment. center,
            children: [
              // subtract icon
              Container(
                height: 25,
                width: 35,
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )
                ),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 10,),

              // number icon
              Container(
                height: 30,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '1',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(width: 10,),

              // add icon
              Container(
                height: 25,
                width: 35,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),


            ],
          ),

          const SizedBox(height: 20,),

          Text(
            '৳11.0',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),

          const SizedBox(height: 20,),

          Container(
            width: 200,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Add To Cart',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white
                ),
              ),
            ),
          ),

        ],
      ),

    );
  }
}
