import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextButtonsCustom extends StatefulWidget {
  @override
  _TextButtonsCustomState createState() => _TextButtonsCustomState();
}

class _TextButtonsCustomState extends State<TextButtonsCustom> {
  final TapGestureRecognizer _gestureRecognizer = TapGestureRecognizer()
    ..onTap = () {
      //Add code to run on text view tap
      debugPrint("Forgot Password was clicked");
    };
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Theme.of(context).primaryColorLight;
      }
      return Theme.of(context).primaryColor;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Forgot Password?",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 16,
              ),
            ),
            recognizer: _gestureRecognizer,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Remember Me",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 16,
                ),
              ),
            ),
            Checkbox(
                checkColor: Theme.of(context).primaryColorLight,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: _isChecked,
                onChanged: (bool? value) => {
                      setState(() {
                        _isChecked = value!;
                      })
                    })
          ],
        ),
      ],
    );
  }
}
