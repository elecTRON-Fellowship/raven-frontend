import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpButtonSignUp extends StatelessWidget {
  void signupUser(BuildContext context) {
    //communicate with backend
    //validate user input
    //if successfully signed up
    Navigator.of(context).pushNamed('/user-info');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signupUser(context),
      child: Text(
        "Sign Up",
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.65,
          MediaQuery.of(context).size.height * 0.07,
        ),
        onPrimary: Colors.white,
        primary: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
