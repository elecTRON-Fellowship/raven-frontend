import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTextSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "back to",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Raven",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
