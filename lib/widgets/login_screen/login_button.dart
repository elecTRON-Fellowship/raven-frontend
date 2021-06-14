import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  final Function loginUser;
  final GlobalKey<FormState> _formkey;

  LoginButton(this.loginUser, this._formkey);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //onPressed: () => loginUser(),
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          loginUser();
        }
      },
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
