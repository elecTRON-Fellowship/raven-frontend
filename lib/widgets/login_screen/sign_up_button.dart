import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/signup');
      },
      child: Text(
        "Sign Up",
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 24,
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.65,
          MediaQuery.of(context).size.height * 0.07,
        ),
        primary: Theme.of(context).primaryColor,
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
