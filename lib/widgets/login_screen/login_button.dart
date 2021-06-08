import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  void loginUser(BuildContext context) {
    //communicate with backend
    //validate user input
    //if successfully signed in
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/conversations', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => loginUser(context),
      child: Text(
        "Login",
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
