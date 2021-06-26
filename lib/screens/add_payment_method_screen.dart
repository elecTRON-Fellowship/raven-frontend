import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPaymentScreen extends StatefulWidget {
  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final _appBar = AppBar(
      elevation: 0.0,
      backgroundColor: theme.primaryColor,
      automaticallyImplyLeading: false,
      title: Text(
        'Add payment method',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        color: theme.primaryColorDark,
      ),
    );
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: _appBar,
      body: Container(
        height: size.height - _appBar.preferredSize.height,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          color: theme.backgroundColor,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Please provide your card details",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 16),
                  color: theme.primaryColorDark,
                ),
              ),
              textFormField(
                  size,
                  theme,
                  TextInputType.name,
                  TextInputAction.next,
                  "Name on card",
                  false,
                  _fullNameValidator),
              textFormField(
                  size,
                  theme,
                  TextInputType.number,
                  TextInputAction.next,
                  "Card number",
                  false,
                  _cardNumberValidator),
              textFormField(
                  size,
                  theme,
                  TextInputType.datetime,
                  TextInputAction.next,
                  "Expiration (MM/YY)",
                  false,
                  _cardExpirationValidator),
              textFormField(size, theme, TextInputType.number,
                  TextInputAction.done, "CVV", true, _cvvValidator),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Validated");
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
    );
  }

  String? Function(String?)? _fullNameValidator = (String? fullName) {
    String pattern = r"^[a-zA-Z\\s]+";
    RegExp regExp = new RegExp(pattern);
    if (fullName!.isEmpty) {
      return 'Required';
    } else if (!regExp.hasMatch(fullName)) {
      return 'Invalid Name';
    }

    return null;
  };

  String? Function(String?)? _cardNumberValidator = (String? cardNumber) {
    String pattern = r"[0-9]{16}";
    RegExp regExp = new RegExp(pattern);
    if (cardNumber!.isEmpty) {
      return 'Required';
    } else if (!regExp.hasMatch(cardNumber)) {
      return 'Invalid Card Number';
    }

    return null;
  };

  String? Function(String?)? _cardExpirationValidator = (String? expDate) {
    String pattern = r"(?:0[1-9]|1[0-2])\/[0-9]{2}";
    RegExp regExp = new RegExp(pattern);
    if (expDate!.isEmpty) {
      return 'Required';
    } else if (!regExp.hasMatch(expDate)) {
      return 'Invalid Date';
    }

    return null;
  };

  String? Function(String?)? _cvvValidator = (String? cvv) {
    if (cvv!.isEmpty) {
      return 'Required';
    } else if (cvv.length != 3) {
      return 'Must be 3 digits';
    }

    return null;
  };

  Widget textFormField(
      final size,
      final theme,
      TextInputType textInputType,
      TextInputAction textInputAction,
      String labelText,
      bool containsObscureText,
      String? Function(String?)? validator) {
    return Container(
      width: size.width * 0.8,
      child: TextFormField(
        keyboardType: textInputType,
        textInputAction: textInputAction,
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
          labelText: labelText,
          labelStyle: TextStyle(
            color: theme.accentColor,
          ),
        ),
        validator: validator,
        obscureText: containsObscureText,
      ),
    );
  }
}
