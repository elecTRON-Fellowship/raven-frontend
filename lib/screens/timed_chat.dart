import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/timed_chat_screen/message_bubble_timed_chat.dart';
import 'package:raven/widgets/timed_chat_screen/timer_card.dart';
import 'package:uuid/uuid.dart';

class TimedChatScreen extends StatefulWidget {
  final String conversationId;
  final String messageId;

  TimedChatScreen({required this.conversationId, required this.messageId});

  @override
  _TimedChatScreenState createState() => _TimedChatScreenState();
}

class _TimedChatScreenState extends State<TimedChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController textController = new TextEditingController();
  final ScrollController scrollController = ScrollController();

  late CollectionReference _timedChatsCollection;

  @override
  void initState() {
    super.initState();
    _timedChatsCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/timedChats');
    doThis();
  }

  void doThis() async {
    await FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages')
        .doc(widget.messageId)
        .update({'status': 'FINISHED'});
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    var textToSend = textController.text;
    textController.clear();

    await _timedChatsCollection.add({
      'time': DateTime.now(),
      'sender': _auth.currentUser!.uid,
      'text': textToSend
    });
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void deleteAllMessages() async {
    final snapshot = await _timedChatsCollection.get();
    snapshot.docs.forEach((doc) async {
      await _timedChatsCollection.doc(doc.id).delete();
    });
  }

  Future<bool> _onBackPressed(context, theme) async {
    return await showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: AlertDialog(
          backgroundColor: theme.backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            "Are you sure?",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColorDark,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Going back will end the session.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                color: theme.primaryColor,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'No',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.accentColor,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteAllMessages();
                Navigator.pop(context, true);
              },
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => _onBackPressed(context, theme),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () async {
              _onBackPressed(context, theme).then((value) {
                if (value) Navigator.of(context).pop();
              });
            },
            icon: Icon(Icons.arrow_back_rounded),
            iconSize: 25,
            color: Theme.of(context).primaryColorDark,
          ),
          centerTitle: true,
          title: Text(
            'Coffee Break',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              TimerCard(
                onTimerFinish: deleteAllMessages,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: StreamBuilder(
                      stream: _timedChatsCollection
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        if (snapshot.hasData) {
                          final documents = (snapshot.data)!.docs;
                          return ListView.builder(
                            key: ValueKey(Uuid().v4()),
                            controller: scrollController,
                            reverse: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) =>
                                MessageBubbleTimedChat(
                              conversationId: widget.conversationId,
                              messageId: documents[index].id,
                              key: ValueKey(documents[index].id),
                              sender: documents[index]['sender'],
                              text: documents[index]['text'],
                              time: DateTime.parse(
                                  documents[index]['time'].toDate().toString()),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 3,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: theme.primaryColorDark,
                              ),
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(
                                  color: theme.primaryColorDark,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(
                                  color: theme.primaryColorDark,
                                  width: 2,
                                ),
                              ),
                              hintText: 'Write your message here...',
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              sendMessage();
                            }
                          },
                          icon: Icon(Icons.send_rounded),
                          color: Theme.of(context).primaryColorDark,
                          iconSize: 30.0,
                          padding: EdgeInsets.only(left: 15),
                        )
                      ],
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
