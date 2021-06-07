import 'package:flutter/material.dart';
import 'package:raven/widgets/sign_up_screen/header_text.dart';
import 'package:raven/widgets/sign_up_screen/main_card_sign_up.dart';
import 'package:raven/widgets/sign_up_screen/top_bg.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              child: TopBackground(),
              top: 0,
              left: 0,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.09,
              left: MediaQuery.of(context).size.width * 0.10,
              child: Container(
                child: HeaderTextSignUp(),
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.33,
              left: MediaQuery.of(context).size.width * 0.075,
              child: Container(
                child: MainCardSignUp(),
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.85,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
