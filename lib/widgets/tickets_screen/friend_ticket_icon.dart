import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendTicketIcon extends StatelessWidget {
  const FriendTicketIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: Icon(Icons.account_circle),
          maxRadius: 30,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          'Jamie',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color.fromRGBO(17, 128, 168, 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
