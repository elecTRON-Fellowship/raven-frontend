import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveButton extends StatelessWidget {
  void saveUser(BuildContext context) {
    //communicate with backend
    //validate user input
    //if successfully signed up
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/conversations', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => saveUser(context),
      child: Text(
        "Save",
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
