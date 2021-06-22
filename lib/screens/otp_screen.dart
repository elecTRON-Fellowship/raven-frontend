import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/user_info.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();

  FirebaseAuth _auth;
  String verificationId;
  String phoneNumber;

  OTPScreen(this._auth, this.verificationId, this.phoneNumber);
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();

  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  bool showLoading = false;

  void signIn(PhoneAuthCredential credential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final userCredential =
          await widget._auth.signInWithCredential(credential);
      setState(() {
        showLoading = false;
      });

      if (userCredential.user != null) {
        var user = userCredential.user;

        final snapshot = await _userCollection.doc(user!.uid.toString()).get();
        final data = snapshot.data();

        if (data == null) {
          await _userCollection.doc(user.uid.toString()).set({
            'phoneNumber': user.phoneNumber.toString(),
            'firstName': '',
            'lastName': '',
            'closeFriends': []
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => UserInfoScreen(user.uid),
            ),
          );
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/conversations', (route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message.toString(),
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // String verificationId =
    //     ModalRoute.of(context)!.settings.arguments.toString();
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
                "We have sent a verification code to your mobile.",
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
              widget.phoneNumber,
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
            showLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColorDark,
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        width: size.width * 0.8,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          controller: otpController,
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
                        onPressed: () async {
                          final PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpController.text,
                          );

                          signIn(credential);
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
          ],
        ),
      ),
    );
  }
}
