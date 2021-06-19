import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/chat_screen.dart/message_bubble.dart';
import 'package:raven/widgets/timed_chat_screen.dart/timer_card.dart';

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
  }

  @override
  void dispose() async {
    super.dispose();
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    await _timedChatsCollection.add({
      'time': DateTime.now(),
      'sender': _auth.currentUser!.uid,
      'text': textController.text,
      'read': false
    });
    textController.clear();
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void deleteAllMessages() async {
    final snapshot = await _timedChatsCollection.get();
    snapshot.docs.forEach((doc) async {
      _timedChatsCollection.doc(doc.id).delete();
    });
  }

  void setTimedChatStatusToFinished() async {
    await FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages')
        .doc(widget.messageId)
        .update({'status': 'FINISHED'});
  }

  Future<bool> _onBackPressed(context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              deleteAllMessages();
              setTimedChatStatusToFinished();
              Navigator.pop(context, true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () async {
                    _onBackPressed(context).then((value) {
                      if (value) Navigator.of(context).pop();
                    });
                  },
                  icon: Icon(Icons.arrow_back_rounded),
                  iconSize: 30,
                  color: Color.fromRGBO(17, 128, 168, 1.0),
                ),
                titleSpacing: 0,
                title: Text(
                  'Coffee Break',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color.fromRGBO(17, 128, 168, 1.0),
                    ),
                  ),
                ),
              ),
            ],
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
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          final documents = (snapshot.data)!.docs;
                          return ListView.builder(
                            controller: scrollController,
                            reverse: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) => MessageBubble(
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
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                            maxLines: 5,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(),
                            ),
                            decoration: InputDecoration(
                              fillColor: Color.fromRGBO(194, 222, 232, 1.0),
                              filled: true,
                              contentPadding: EdgeInsets.all(13),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 2,
                                ),
                              ),
                              hintText: 'Write your message here...',
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          onPressed: () => sendMessage(),
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
