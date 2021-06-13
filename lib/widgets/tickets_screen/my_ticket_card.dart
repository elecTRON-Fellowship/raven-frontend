import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_contributor_card.dart';

class MyTicketCard extends StatelessWidget {
  final Function contributorCardOnTap;

  MyTicketCard({required this.contributorCardOnTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 3.0,
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mizan Ali',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: Text(
                    'Need money to buy tickets for Abu Dhabi GP.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Color.fromRGBO(17, 128, 168, 1.0),
                      ),
                    ),
                  ),
                ),
                Text(
                  '90/100',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromRGBO(17, 128, 168, 1.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            MyTicketContributorCard(
                backgroundColor: Color.fromRGBO(212, 230, 237, 1.0),
                onTap: this.contributorCardOnTap),
          ],
        ),
      ),
    );
  }
}
