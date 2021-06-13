import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendTicketIcon extends StatelessWidget {
  final String name;

  FriendTicketIcon({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/friend-transactions',
                arguments: {'friendName': this.name});
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/a/a0/Arh-avatar.jpg',
            ),
            radius: 33,
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          this.name,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ],
    );
  }
}
