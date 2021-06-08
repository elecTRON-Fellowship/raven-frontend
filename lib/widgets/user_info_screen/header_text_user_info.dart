import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderTextUserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Tell Us",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "About",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Yourself",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
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
