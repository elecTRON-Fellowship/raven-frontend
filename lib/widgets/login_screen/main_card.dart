import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/login_screen/login_button.dart';
import 'package:raven/widgets/login_screen/password_edit_text.dart';
import 'package:raven/widgets/login_screen/phone_number_text_field.dart';
import 'package:raven/widgets/login_screen/sign_up_button.dart';
import 'package:raven/widgets/login_screen/text_buttons.dart';

class MainCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PhoneNumberTextField(),
          PasswordEditText(),
          TextButtonsCustom(),
          LoginButton(),
          SignUpButton(),
        ],
      ),
    );
  }
}
