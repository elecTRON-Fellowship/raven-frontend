import 'package:flutter/material.dart';
import 'package:fzregex/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';

class PasswordEditTextSignUp extends StatefulWidget {
  final passwordController;

  PasswordEditTextSignUp(this.passwordController);

  @override
  _PasswordEditTextSignUpState createState() => _PasswordEditTextSignUpState();
}

class _PasswordEditTextSignUpState extends State<PasswordEditTextSignUp> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
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
        // validator: (value) {
        //   // if (value!.trim().isEmpty) {
        //   //   return "Please enter a password";
        //   // }
        //   var isValidPassword =
        //       Fzregex.hasMatch(value!, FzPattern.passwordNormal1);
        //   if (!isValidPassword) {
        //     return "Invalid/Weak password";
        //   }
        //   return null;
        // },
      ),
    );
  }
}
