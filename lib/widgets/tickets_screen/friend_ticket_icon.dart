import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendTicketIcon extends StatelessWidget {
  const FriendTicketIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/a/a0/Arh-avatar.jpg',
          ),
          radius: 33,
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          'Jamie',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color.fromRGBO(17, 128, 168, 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
