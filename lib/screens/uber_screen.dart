import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UberScreen extends StatelessWidget {
  const UberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 25,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Uber',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontSize: 64),
                )),
            SizedBox(
              height: size.height * 0.1,
            ),
            Text('For depiction purposes only',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontSize: 18),
                )),
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
                'This section of the app will be implented using a full API integration of a popular cab services provider.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14),
                )),
            SizedBox(
              height: size.height * 0.045,
            ),
            Text('Here Uber is taken as an example.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontSize: 14),
                )),
          ],
        ),
      ),
    );
  }
}
