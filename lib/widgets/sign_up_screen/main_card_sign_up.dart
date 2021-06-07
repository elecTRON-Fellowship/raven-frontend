import 'package:flutter/material.dart';
import 'package:raven/widgets/login_screen/phone_number_text_field.dart';
import 'package:raven/widgets/sign_up_screen/email_edit_text.dart';
import 'package:raven/widgets/sign_up_screen/password_edit_text_sign_up.dart';
import 'package:raven/widgets/sign_up_screen/phone_number_edit_text_sign_up.dart';
import 'package:raven/widgets/sign_up_screen/sign_up_button_sign_up.dart';

class MainCardSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PhoneNumberTextFieldSignUp(),
          EmailEditText(),
          PasswordEditTextSignUp(),
          SignUpButtonSignUp(),
        ],
      ),
    );
  }
}
