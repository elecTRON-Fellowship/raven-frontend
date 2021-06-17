import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendTicketIcon extends StatelessWidget {
  final String name;

  FriendTicketIcon({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/friend-transactions',
                arguments: {'friendName': this.name});
          },
          child: CircleAvatar(
            backgroundColor: theme.accentColor,
            child: Text(
              this.name.isNotEmpty
                  ? this.name.trim().split(' ').map((l) => l[0]).take(2).join()
                  : '',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              )),
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
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
