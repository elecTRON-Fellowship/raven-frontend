import 'package:flutter/material.dart';
import 'package:fzregex/utils/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';

class PhoneNumberTextField extends StatelessWidget {
  final phoneNumberController;

  PhoneNumberTextField(this.phoneNumberController);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextFormField(
        controller: this.phoneNumberController,
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
        validator: (value) {
          var isValid =
              Fzregex.hasMatch(value!, FzPattern.phone); //Hard coded +91
          if (!isValid) {
            return "Invalid phone number";
          }
          return null;
        },
      ),
    );
  }
}
