import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendTicketCard extends StatelessWidget {
  final String friendName;
  final String description;
  final double amountRaised;
  final double totalAmount;

  FriendTicketCard(
      {required this.friendName,
      required this.description,
      required this.amountRaised,
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
              this.friendName,
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
            Container(
              width: double.infinity,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Contribute',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10)),
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColorDark),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).backgroundColor,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}