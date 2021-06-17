import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../user_singleton.dart';

class AddressDetailsScreen extends StatefulWidget {
  @override
  _AddressDetailsScreenState createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  final _addressInfoKey = GlobalKey<FormState>();
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
            key: _addressInfoKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  "Enter your permanent address details",
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
                    keyboardType: TextInputType.streetAddress,
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
                      labelText: "Address line 1",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r"[A-Za-z0-9'\.\-\s\,]";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid Input';
                      }
                      _userInfoSingleton.addressLine1(value);
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
                    keyboardType: TextInputType.streetAddress,
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
                      labelText: "Address line 2",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r"[A-Za-z0-9'\.\-\s\,]";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      }
                      _userInfoSingleton.addressLine2(value);
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
                    keyboardType: TextInputType.streetAddress,
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
                      labelText: "Address line 3",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r"[A-Za-z0-9'\.\-\s\,]";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      }
                      _userInfoSingleton.addressLine3(value);
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
                      labelText: "City",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r"[A-Za-z0-9'\.\-\s\,]";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      }
                      _userInfoSingleton.city(value);
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
                      labelText: "State",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r"[A-Za-z0-9'\.\-\s\,]";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      }
                      _userInfoSingleton.state(value);
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
                      labelText: "Country",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r"[A-Za-z0-9'\.\-\s\,]";
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      }
                      _userInfoSingleton.country(value);
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
                      labelText: "Zip",
                      labelStyle: TextStyle(
                        color: theme.accentColor,
                      ),
                    ),
                    validator: (value) {
                      String pattern = r'^[1-9][0-9]*$';
                      RegExp regExp = new RegExp(pattern);
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Invalid input';
                      } else if (value.length != 6) {
                        return "Must be 6 digits";
                      }
                      _userInfoSingleton.zip(value);
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_addressInfoKey.currentState!.validate()) {
                      //storeUserDetails();
                      _userInfoSingleton.printData1();
                      _userInfoSingleton.printData2();
                    }
                  },
                  child: Text(
                    "Create Wallet",
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
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
