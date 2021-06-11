import 'package:flutter/material.dart';

class PasswordEditText extends StatefulWidget {
  final passwordController;

  PasswordEditText(this.passwordController);

  @override
  _PasswordEditTextState createState() => _PasswordEditTextState();
}

class _PasswordEditTextState extends State<PasswordEditText> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextField(
        controller: widget.passwordController,
        style: TextStyle(
          fontSize: 16,
          height: 1,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          //errorText: "Please check the Password",
          labelText: "Password",
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
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
          suffixIcon: IconButton(
            icon: _isPasswordVisible
                ? Icon(
                    Icons.visibility_off,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(Icons.visibility, color: Theme.of(context).primaryColor),
            onPressed: () => setState(
              () => _isPasswordVisible = !_isPasswordVisible,
            ),
          ),
        ),
        obscureText: !_isPasswordVisible,
        //onSubmitted: (String) {}, //Run login method
      ),
    );
  }
}
