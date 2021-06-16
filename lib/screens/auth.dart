import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/otp_screen.dart';

const String logo = "assets/vectors/raven_logo.svg";

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = '';
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            child: headerLogo(context, theme, size),
            top: size.height * 0.07,
            left: size.width * 0.3,
          ),
          Positioned(
            child: Text(
              "Raven",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  color: theme.primaryColorDark,
                ),
              ),
            ),
            top: size.height * 0.32,
            left: size.width * 0.415,
          ),
          Positioned(
            child: bottomBackground(context, size, theme),
            top: size.height * 0.4,
            left: 0,
          ),
          showLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: theme.primaryColorDark,
                  ),
                )
              : Positioned(
                  child: mainForm(context, size, theme, _formKey),
                  top: size.height * 0.4,
                  left: size.width * 0.075,
                ),
        ],
      ),
    );
  }

  Widget headerLogo(BuildContext context, var theme, var size) {
    return Container(
      height: size.height * 0.25,
      width: size.width * 0.4,
      color: theme.primaryColor,
      child: SvgPicture.asset(
        logo,
        color: theme.primaryColorDark,
      ),
    );
  }

  Widget bottomBackground(BuildContext context, var size, var theme) {
    return Container(
      height: size.height * 0.6,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        color: theme.backgroundColor,
      ),
    );
  }

  Widget mainForm(BuildContext context, var size, var theme, var formKey) {
    return Container(
      color: theme.backgroundColor,
      height: size.height * 0.6,
      width: size.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.04,
          ),
          Container(
            width: size.width * 0.8,
            child: Text(
              "Hey there, \nWelcome to Raven",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontSize: 24,
                color: theme.primaryColorDark,
              )),
            ),
          ),
          SizedBox(
            height: size.height * 0.07,
          ),
          Form(
            key: formKey,
            child: Container(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  fontSize: 14,
                  height: 1,
                  color: theme.accentColor,
                ),
                decoration: InputDecoration(
                  prefixText: '+91 ',
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
                  labelText: "Phone Number",
                  labelStyle: TextStyle(
                    color: theme.accentColor,
                  ),
                ),
                validator: (value) {
                  String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                  RegExp regExp = new RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return 'Phone Number is required';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.07,
          ),
          Container(
            width: size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        showLoading = true;
                      });

                      await _auth.verifyPhoneNumber(
                        phoneNumber: '+91${phoneController.text}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) async {
                          setState(() {
                            showLoading = false;
                          });
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/conversations', (route) => false);
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          showLoading = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.message.toString(),
                                style: TextStyle(
                                    color: theme.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              backgroundColor: theme.primaryColor,
                            ),
                          );
                        },
                        codeSent:
                            (String verificationId, int? resendToken) async {
                          setState(() {
                            showLoading = false;
                            this.verificationId = verificationId;

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OTPScreen(
                                    _auth,
                                    this.verificationId,
                                    '+91 ${phoneController.text}'),
                              ),
                            );
                          });
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    }
                  },
                  child: Text(
                    "Login",
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
                      size.height * 0.08,
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
        ],
      ),
    );
  }
}
