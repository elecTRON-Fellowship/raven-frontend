import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTicketContributorCard extends StatelessWidget {
  const MyTicketContributorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(212, 230, 237, 1.0),
        borderRadius: BorderRadius.circular(15),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: FittedBox(
                  child: Icon(Icons.account_circle),
                ),
                maxRadius: 8,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Zaid Sheikh',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(17, 128, 168, 1.0),
                  ),
                ),
              ),
            ],
          ),
          Text(
            '+ 200',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color.fromRGBO(17, 128, 168, 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
