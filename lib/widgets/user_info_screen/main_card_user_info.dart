import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raven/providers/user.dart';
import 'package:raven/widgets/user_info_screen/first_name_edit_text.dart';
import 'package:raven/widgets/user_info_screen/last_name_edit_text.dart';
import 'package:raven/widgets/user_info_screen/save_button.dart';
import 'package:raven/widgets/user_info_screen/username_edit_text.dart';

class MainCardUserInfo extends StatefulWidget {
  final signUpCredentials;

  MainCardUserInfo({required this.signUpCredentials});

  @override
  _MainCardUserInfoState createState() => _MainCardUserInfoState();
}

class _MainCardUserInfoState extends State<MainCardUserInfo> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _saveFormKey = GlobalKey<FormState>();

  void onSaveButtonPressed(BuildContext context) {
    Provider.of<User>(context, listen: false)
        .register(
            _firstNameController.text.toString(),
            _lastNameController.text.toString(),
            _usernameController.text.toString(),
            widget.signUpCredentials['email'].toString(),
            widget.signUpCredentials['password'].toString(),
            widget.signUpCredentials['phoneNumber'].toString())
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
        key: _saveFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FirstNameEditText(_firstNameController),
            LastNameEditText(_lastNameController),
            UsernameEditText(_usernameController),
            SaveButton(() => onSaveButtonPressed(context), _saveFormKey),
          ],
        ),
      ),
    );
  }
}
