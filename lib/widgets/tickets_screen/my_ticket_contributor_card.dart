import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTicketContributorCard extends StatefulWidget {
  final String contributorId;
  final double amountContributed;
  final Color backgroundColor;
  final Function onTap;

  MyTicketContributorCard(
      {required this.contributorId,
      required this.amountContributed,
      required this.backgroundColor,
      required this.onTap});

  @override
  _MyTicketContributorCardState createState() =>
      _MyTicketContributorCardState();
}

class _MyTicketContributorCardState extends State<MyTicketContributorCard> {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  String fetchedName = '';

  @override
  void initState() {
    super.initState();
    fetchContributorName();
  }

  fetchContributorName() async {
    final snapshot = await _userCollection.doc(widget.contributorId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      // margin: EdgeInsets.symmetric(vertical: 5),
      height: size.height * 0.055,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashColor: Theme.of(context).primaryColorLight,
        onTap: () => this.widget.onTap(),
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
                      fetchedName.isNotEmpty
                          ? fetchedName
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
                    radius: 16,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    fetchedName,
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
                '₹${this.widget.amountContributed.toStringAsFixed(2)}',
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
