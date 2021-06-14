import 'package:flutter/material.dart';
import 'package:fzregex/utils/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';

class UsernameEditText extends StatelessWidget {
  final usernameController;

  UsernameEditText(this.usernameController);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextFormField(
        controller: this.usernameController,
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
        // validator: (value) {
        //   var isValid = Fzregex.hasMatch(value!, FzPattern.name);
        //   if (!isValid) {
        //     return "Invalid username";
        //   }
        //   //add checks for special characters
        //   return null;
        // },
      ),
    );
  }
}
