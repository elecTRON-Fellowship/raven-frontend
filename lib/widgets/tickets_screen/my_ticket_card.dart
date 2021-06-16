import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_contributor_card.dart';

class MyTicketCard extends StatelessWidget {
  final Function contributorCardOnTap;
  final String description;
  final double amountRaised;
  final double totalAmount;

  MyTicketCard(
      {required this.contributorCardOnTap,
      required this.amountRaised,
      required this.description,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 3.0,
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // '${userData['firstName'] as String} ${userData['lastName'] as String}',
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
                    this.description,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.5,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ),
                Text(
                  '₹${this.amountRaised.toStringAsFixed(2)}/\n₹${this.totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            MyTicketContributorCard(
                contributorName: 'Zaid Sheikh',
                amountContributed: 200,
                backgroundColor: Theme.of(context).backgroundColor,
                onTap: this.contributorCardOnTap),
          ],
        ),
      ),
    );
  }
}
