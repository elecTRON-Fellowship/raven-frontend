import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationCard extends StatelessWidget {
  final String name;
  final String lastText;
  final int unreadTexts;

  ConversationCard(this.name, this.lastText, this.unreadTexts);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.5, horizontal: 10),
      width: double.infinity,
      height: 95,
      child: Card(
        color: Color.fromRGBO(212, 230, 237, 1.0),
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Container(
                width: 90,
                child: Icon(
                  Icons.account_circle,
                  size: 60,
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.name,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black)),
                ),
                Text(
                  this.lastText,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 15, color: Colors.grey)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
