import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raven/providers/user.dart';

import 'package:raven/widgets/login_screen/login_button.dart';
import 'package:raven/widgets/login_screen/password_edit_text.dart';
import 'package:raven/widgets/login_screen/phone_number_text_field.dart';
import 'package:raven/widgets/login_screen/sign_up_button.dart';
import 'package:raven/widgets/login_screen/text_buttons.dart';

class MainCard extends StatefulWidget {
  @override
  _MainCardState createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void onLoginButtonPressed(BuildContext context) {
    Provider.of<User>(context, listen: false)
        .login(
      _phoneNumberController.text.toString(),
      _passwordController.text.toString(),
    )
        .then((res) {
      if (res) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/conversations', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("There was an error")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PhoneNumberTextField(_phoneNumberController),
            PasswordEditText(_passwordController),
            TextButtonsCustom(),
            LoginButton(() => onLoginButtonPressed(context), _formKey),
            SignUpButton(),
          ],
        ),
      ),
    );
  }
}
