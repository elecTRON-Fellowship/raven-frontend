import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:raven/screens/chat.dart';

class ConversationCard extends StatefulWidget {
  final String friendUserId;

  final int unreadTexts;

  final String conversationId;

  ConversationCard(
      {required this.friendUserId,
      required this.unreadTexts,
      required this.conversationId});

  @override
  _ConversationCardState createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  late CollectionReference _messagesCollection;

  String fetchedName = '';
  String fetchedLastText = '';
  String fetchedLastTextTime = '';

  @override
  void initState() {
    super.initState();
    _messagesCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages');
    fetchContactName();
  }

  fetchContactName() async {
    final snapshot = await _userCollection.doc(widget.friendUserId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  void selectConversation(BuildContext context, String name) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              conversationId: widget.conversationId,
              friendName: fetchedName,
            ),
          ),
        )
        .then((_) => setState(() {}));
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
                  backgroundColor: Theme.of(context).primaryColorDark,
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
                  radius: 24,
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _messagesCollection
                          .orderBy('time', descending: true)
                          .limit(1)
                          .get()
                          .asStream(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('');
                        }
                        if (snapshot.hasData) {
                          final documents = (snapshot.data)!.docs;
                          final data =
                              documents[0].data() as Map<String, dynamic>;
                          String lastText = data['text'];
                          return Text(
                            lastText,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          );
                        } else {
                          return Text('');
                        }
                      },
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
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _messagesCollection
                            .orderBy('time', descending: true)
                            .limit(1)
                            .get()
                            .asStream(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('');
                          }
                          if (snapshot.hasData) {
                            final documents = (snapshot.data)!.docs;
                            final data =
                                documents[0].data() as Map<String, dynamic>;
                            String lastTextTime = DateFormat.Hm().format(
                                DateTime.parse(
                                    data['time'].toDate().toString()));
                            return Text(
                              lastTextTime,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14, color: Colors.blueGrey)),
                            );
                          } else {
                            return Text('');
                          }
                        },
                      ),
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
