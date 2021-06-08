import 'package:flutter/material.dart';
import 'package:raven/widgets/user_info_screen/first_name_edit_text.dart';
import 'package:raven/widgets/user_info_screen/last_name_edit_text.dart';
import 'package:raven/widgets/user_info_screen/save_button.dart';
import 'package:raven/widgets/user_info_screen/username_edit_text.dart';

class MainCardUserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FirstNameEditText(),
          LastNameEditText(),
          UsernameEditText(),
          SaveButton(),
        ],
      ),
    );
  }
}
