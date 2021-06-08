import 'package:flutter/material.dart';
import 'package:raven/widgets/user_info_screen/header_text_user_info.dart';
import 'package:raven/widgets/user_info_screen/main_card_user_info.dart';
import 'package:raven/widgets/user_info_screen/top_bg_user_info.dart';

class UserInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                child: TopBackgroundUserInfo(),
                top: 0,
                left: 0,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.09,
                left: MediaQuery.of(context).size.width * 0.10,
                child: Container(
                  child: HeaderTextUserInfo(),
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.33,
                left: MediaQuery.of(context).size.width * 0.075,
                child: Container(
                  child: MainCardUserInfo(),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.85,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
