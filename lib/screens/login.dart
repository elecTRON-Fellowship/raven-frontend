import 'package:flutter/material.dart';
import 'package:raven/widgets/login_screen/bottom_bg.dart';
import 'package:raven/widgets/login_screen/header_text.dart';
import 'package:raven/widgets/login_screen/main_card.dart';

class LoginScreen extends StatelessWidget {
  //const LoginScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.6,
                left: 0,
                child: BottomBackground(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.09,
                left: MediaQuery.of(context).size.width * 0.10,
                child: Container(
                  child: HeaderText(),
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.33,
                left: MediaQuery.of(context).size.width * 0.075,
                child: Container(
                  child: MainCard(),
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
