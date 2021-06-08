import 'package:flutter/material.dart';

class PhoneNumberTextField extends StatefulWidget {
  @override
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 16,
          height: 1,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColorDark,
              width: 2,
            ),
          ),
          //errorText: "Please check the username",
          labelText: "Phone No",
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
    );
  }
}
