import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTicketContributorCard extends StatelessWidget {
  final String contributorName;
  final double amountContributed;
  final Color backgroundColor;
  final Function onTap;

  MyTicketContributorCard(
      {required this.contributorName,
      required this.amountContributed,
      required this.backgroundColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: Card(
        elevation: 2.5,
        color: this.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          splashColor: Theme.of(context).primaryColorLight,
          onTap: () => this.onTap(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/a/a0/Arh-avatar.jpg',
                      ),
                      radius: 15,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      this.contributorName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${this.amountContributed.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
