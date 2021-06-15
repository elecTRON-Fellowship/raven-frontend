import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatelessWidget {
  final _OTPInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        title: Text(
          "Verification",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primaryColorDark),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/login');
            },
            icon: Icon(
              Icons.arrow_back,
              color: theme.primaryColorDark,
            )),
      ),
      body: Container(
        height: size.height * 0.9,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: theme.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              width: size.width * 0.8,
              child: Text(
                "We have sent a verification code to your mobile",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  color: theme.primaryColorDark,
                  fontSize: 18,
                )),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              "1234567890",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                color: theme.accentColor,
                fontSize: 24,
              )),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              width: size.width * 0.8,
              child: TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                controller: _OTPInputController,
                style: TextStyle(
                  fontSize: 16,
                  height: 1,
                  color: theme.accentColor,
                ),
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: theme.accentColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: theme.accentColor,
                      width: 2,
                    ),
                  ),
                  labelText: "Verification Code",
                  labelStyle: TextStyle(
                    color: theme.accentColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _OTPInputController.text,
                      style: TextStyle(
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                );
                print(_OTPInputController.text);
              },
              child: Text(
                "Verify",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(
                  size.width * 0.6,
                  size.height * 0.07,
                ),
                onPrimary: theme.backgroundColor,
                primary: theme.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
