import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveButton extends StatelessWidget {
  final Function saveUser;
  final GlobalKey<FormState> _saveFormKey;

  SaveButton(this.saveUser, this._saveFormKey);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //onPressed: () => this.saveUser(),
      onPressed: () {
        if (_saveFormKey.currentState!.validate()) {
          this.saveUser();
        }
      },
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
