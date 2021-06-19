import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/address_details_screen.dart';
import 'package:raven/models/user_singleton.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _userInfoKey = GlobalKey<FormState>();
  final _userInfoSingleton = UserDataSingleton();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Wallet",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
          color: theme.primaryColorDark,
        ),
      ),
      backgroundColor: theme.primaryColor,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          color: theme.backgroundColor,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _userInfoKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  "Tell us about yourself,",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.accentColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
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
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern =
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      _userInfoSingleton.email(value);
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.accentColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
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
                      labelText: "Mother's name",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r'[A-Za-z]+[. ]*([A-Za-z]+[ ]*)*';
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid name';
                      }
                      _userInfoSingleton.mothersName(value);
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.accentColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
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
                      labelText: "DOB dd/mm/yyyy",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern =
                          r"^([0-2][0-9]||3[0-1])/(0[0-9]||1[0-2])/([0-9][0-9])?[0-9][0-9]$";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'DOB is required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid Date';
                      }
                      _userInfoSingleton.dob(value);
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.accentColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
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
                      labelText: "Nationality",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern =
                          r'[^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$';
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Nationality is required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      }
                      _userInfoSingleton.nationality(value);
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.accentColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
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
                      labelText: "ID number",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r"[0-9]{12}";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'ID is required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      } else if (value.length > 12) {
                        return "Can't be more than 12 digits";
                      }
                      _userInfoSingleton.idNumber(value);
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_userInfoKey.currentState!.validate()) {
                      _userInfoSingleton.printData1();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return AddressDetailsScreen();
                        },
                      ));
                    }
                  },
                  child: Text(
                    "Save",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
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
      ),
    );
  }
}
