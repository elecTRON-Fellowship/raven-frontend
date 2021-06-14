import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpButtonSignUp extends StatelessWidget {
  final Function onSignUpButtonPressed;
  final GlobalKey<FormState> _signUpFormKey;

  SignUpButtonSignUp(this.onSignUpButtonPressed, this._signUpFormKey);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //onPressed: () => this.onSignUpButtonPressed(),
      onPressed: () {
        if (_signUpFormKey.currentState!.validate()) {
          this.onSignUpButtonPressed();
        }
      },
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
