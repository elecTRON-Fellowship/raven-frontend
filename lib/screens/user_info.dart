import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();

  String userUid;

  UserInfoScreen(this.userUid);
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _signUpFormKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool showLoading = false;

  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  void storeUserDetails() async {
    setState(() {
      showLoading = true;
    });
    await _userCollection.doc(widget.userUid.toString()).update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text
    });
    setState(() {
      showLoading = false;
    });

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/conversations', (route) => false);
  }

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
            child: headertext(context, theme),
            top: size.height * 0.06,
            left: size.width * 0.10,
          ),
          Positioned(
            child: bottomBackground(context, size, theme),
            top: size.height * 0.3,
            left: 0,
          ),
          showLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: theme.primaryColorDark,
                  ),
                )
              : Positioned(
                  child: mainForm(context, size, theme, _signUpFormKey),
                  top: size.height * 0.3,
                  left: size.width * 0.075,
                ),
        ],
      ),
    );
  }

  Widget headertext(BuildContext context, var theme) {
    return Container(
      color: theme.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: theme.backgroundColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Welcome to",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: theme.backgroundColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Raven",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: theme.primaryColorDark,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomBackground(BuildContext context, var size, var theme) {
    return Container(
      height: size.height * 0.7,
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
      height: size.height * 0.7,
      width: size.width * 0.8,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: size.height * 0.04,
              ),
              Container(
                width: size.width * 0.8,
                child: Text(
                  "Tell us about yourself",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark,
                  )),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: firstNameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
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
                  labelText: "First Name",
                  labelStyle: TextStyle(
                    color: theme.accentColor,
                  ),
                ),
                validator: (value) {
                  String pattern =
                      r'[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$';
                  RegExp regExp = new RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Invalid input';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: lastNameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
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
                  labelText: "Last Name",
                  labelStyle: TextStyle(
                    color: theme.accentColor,
                  ),
                ),
                validator: (value) {
                  String pattern =
                      r'[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$';
                  RegExp regExp = new RegExp(pattern);
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Invalid input';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    storeUserDetails();
                  }
                },
                child: Text(
                  "Sign Up",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
