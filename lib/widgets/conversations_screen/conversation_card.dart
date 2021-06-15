import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationCard extends StatefulWidget {
  final String userId;
  final String lastText;
  final int unreadTexts;
  final String time;

  ConversationCard(this.userId, this.lastText, this.unreadTexts, this.time);

  @override
  _ConversationCardState createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  String fetchedName = '';

  @override
  void initState() {
    super.initState();
    fetchContactName();
  }

  fetchContactName() async {
    final snapshot = await _userCollection.doc(widget.userId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  void selectConversation(BuildContext context, String name) {
    Navigator.of(context).pushNamed('/chat', arguments: {'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4, left: 10, right: 10),
      width: double.infinity,
      height: 88,
      child: Card(
        color: Theme.of(context).backgroundColor,
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () => selectConversation(context, this.fetchedName),
          borderRadius: BorderRadius.circular(15),
          splashColor: Theme.of(context).primaryColorLight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/a/a0/Arh-avatar.jpg',
                  ),
                  radius: 30,
                ),
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 13,
                  ),
                  Text(
                    this.fetchedName,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueGrey)),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.575,
                    child: Text(
                      this.widget.lastText,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      this.widget.time,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 14, color: Colors.blueGrey)),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (this.widget.unreadTexts != 0)
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: FittedBox(
                          child: Text(
                            this.widget.unreadTexts.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
