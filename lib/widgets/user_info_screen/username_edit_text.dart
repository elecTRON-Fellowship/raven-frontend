import 'package:flutter/material.dart';

class UsernameEditText extends StatefulWidget {
  @override
  _UsernameEditTextState createState() => _UsernameEditTextState();
}

class _UsernameEditTextState extends State<UsernameEditText> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextField(
        controller: _usernameController,
        keyboardType: TextInputType.text,
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
          labelText: "Username",
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
    );
  }
}
