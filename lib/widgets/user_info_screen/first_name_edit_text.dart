import 'package:flutter/material.dart';

class FirstNameEditText extends StatefulWidget {
  @override
  _FirstNameEditTextState createState() => _FirstNameEditTextState();
}

class _FirstNameEditTextState extends State<FirstNameEditText> {
  final _firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextField(
        textCapitalization: TextCapitalization.words,
        controller: _firstNameController,
        keyboardType: TextInputType.name,
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
          labelText: "First Name",
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
    );
  }
}
