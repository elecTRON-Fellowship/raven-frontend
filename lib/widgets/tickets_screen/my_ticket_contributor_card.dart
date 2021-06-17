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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: theme.primaryColorDark)),
      height: size.height * 0.055,
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
                    backgroundColor: theme.accentColor,
                    child: Text(
                      this.contributorName.isNotEmpty
                          ? this
                              .contributorName
                              .trim()
                              .split(' ')
                              .map((l) => l[0])
                              .take(2)
                              .join()
                          : '',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      )),
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
    );
  }
}
