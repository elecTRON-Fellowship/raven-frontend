import 'package:flutter/material.dart';
import 'package:raven/widgets/login_screen/phone_number_text_field.dart';
import 'package:raven/widgets/sign_up_screen/email_edit_text.dart';
import 'package:raven/widgets/sign_up_screen/password_edit_text_sign_up.dart';
import 'package:raven/widgets/sign_up_screen/phone_number_edit_text_sign_up.dart';
import 'package:raven/widgets/sign_up_screen/sign_up_button_sign_up.dart';

class MainCardSignUp extends StatefulWidget {
  @override
  _MainCardSignUpState createState() => _MainCardSignUpState();
}

class _MainCardSignUpState extends State<MainCardSignUp> {
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onSignUpButtonPressed() {
    Navigator.of(context).pushNamed('/user-info', arguments: {
      'phoneNumber': _phoneNumberController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PhoneNumberTextFieldSignUp(_phoneNumberController),
          EmailEditText(_emailController),
          PasswordEditTextSignUp(_passwordController),
          SignUpButtonSignUp(_onSignUpButtonPressed),
        ],
      ),
    );
  }
}
