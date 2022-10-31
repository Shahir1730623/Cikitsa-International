import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Expanded(
          child: Column(
            children: [
              Text(
                'Medicine Cart',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black
                ),
              ),

              Text(
                '2 items in Total',
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),

        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded,size: 25,),
          color: Colors.black,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // First medicine Container
            GestureDetector(
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineDetailsScreen()));
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/pharmacyImages/Napa.png',
                      width: 70,
                    ),

                    SizedBox(width: 20,),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            'Napa',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),

                          const SizedBox(height: 5,),

                          Text(
                            'Tablet',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 10,),

                          Text(
                              'Paracetamol 500 mg',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              )
                          ),

                          const SizedBox(height: 5,),

                          Text(
                              'Beximco Pharmaceuticals',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              )
                          ),

                          SizedBox(height: 10,),

                          Text(
                            '৳11.0',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8,),

                    Column(
                      children: [
                        const SizedBox(height: 20,),
                        // Add
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),

                        // Subtract
                        Container(
                          height: 35,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20,),

                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '0',
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20,),

            // Second medicine Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/pharmacyImages/kevirub.png',
                    width: 70,
                  ),

                  SizedBox(width: 20,),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(
                          'Kevirub 50 ml',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 5,),

                        Text(
                          'Handub',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 10,),

                        Text(
                            'Chlorhexidine Gluconate + Isopropyl alcohol',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            )
                        ),

                        const SizedBox(height: 5,),

                        Text(
                            'Beximco Pharmaceuticals',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            )
                        ),

                        SizedBox(height: 10,),

                        Text(
                          '৳150.0',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8,),

                  Column(
                    children: [
                      const SizedBox(height: 20,),
                      // Add
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),

                      // Subtract
                      Container(
                        height: 35,
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '0',
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              height: 2,
              color: Colors.black,
            ),

            const SizedBox(height: 20,),

            // Delivery To
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.location_city,color: Colors.white,)
                ),

                const SizedBox(width: 20,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery To',
                        style: GoogleFonts.montserrat(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      const SizedBox(height: 10,),

                      Text(
                        'Gulshan-1, Road-7, House-817',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),

                    ],
                  ),
                )

              ],
            ),

            const SizedBox(height: 20,),

            // Promo Code (Icon & Text)
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.discount,color: Colors.white,)
                ),

                SizedBox(width: 20,),

                Text(
                  'Promo Code',
                  style: GoogleFonts.montserrat(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),

            const SizedBox(height: 20,),

            // Promo Code TextField Container
            Container(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Promo code',
                        hintStyle: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.black
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Apply',
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20,),

            // Sub Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Sub Total',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),

                Text(
                  '210',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),

            // Promotion
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Promotion',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),

                Text(
                  '20',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),

            // Delivery Fee
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Delivery Fee',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                Text(
                  '20',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),

            const Divider(
              height: 2,
              color: Colors.black,
            ),

            const SizedBox(height: 20,),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),

                Text(
                  '210',
                  style: TextStyle(
                    fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40,),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Checkout Button
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),

                      Text(
                        'Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(width: 20,),

                // Buy More Button
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),

                      Text(
                        'Buy More',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),
          ],
        ),
      ),

    );
  }
}
