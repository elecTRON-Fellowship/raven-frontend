import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatefulWidget {
  final String friendUserId;
  final String status;
  final String description;
  final DateTime date;
  final double amount;

  TransactionCard(
      {required this.friendUserId,
      required this.amount,
      required this.date,
      required this.description,
      required this.status});

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  String fetchedName = '';

  @override
  void initState() {
    super.initState();
    fetchContactName();
  }

  fetchContactName() async {
    final snapshot = await _userCollection.doc(widget.friendUserId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    if (!mounted) return;

    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.primaryColorDark)),
      width: double.infinity,
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(8),
        childrenPadding: EdgeInsets.all(8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
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
                      fontSize: 16,
                      color: Colors.white,
                    )),
                  ),
                  radius: 18,
                ),
                SizedBox(
                  width: 13,
                ),
                Text(
                  fetchedName,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.primaryColorDark)),
                ),
              ],
            ),
            Text(
              DateFormat.yMd().format(this.widget.date),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 15,
                  color: theme.accentColor,
                ),
              ),
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              this.widget.status,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 15,
                  color: theme.accentColor,
                ),
              ),
            ),
            Text(
              '₹${this.widget.amount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.primaryColorDark,
                ),
              ),
            ),
          ],
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.6,
                child: Text(
                  this.widget.description,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
              ),
              Text(
                DateFormat.jm().format(this.widget.date),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: theme.accentColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
