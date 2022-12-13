import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageDialog extends StatefulWidget {
  const UploadImageDialog({Key? key}) : super(key: key);

  @override
  State<UploadImageDialog> createState() => _UploadImageDialogState();
}

class _UploadImageDialogState extends State<UploadImageDialog> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 280),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.04,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context,ImageSource.camera);
              },
              child: Text(
                "Take Photo",
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
            ),

            const Divider(
              height: 50,
              thickness: 1,
              color:Colors.black,
            ),

            GestureDetector(
              onTap: (){
                Navigator.pop(context,ImageSource.gallery);
              },
              child: Text(
                'Upload from Gallery',
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 20
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
