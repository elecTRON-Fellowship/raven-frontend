import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendTransactionCard extends StatelessWidget {
  final String status;
  final String description;
  final String date;
  final double amount;

  FriendTransactionCard(
      {required this.amount,
      required this.date,
      required this.description,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      width: double.infinity,
      child: Card(
        color: Theme.of(context).backgroundColor,
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.status,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  Text(
                    this.date,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.description,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  Text(
                    '₹${this.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
