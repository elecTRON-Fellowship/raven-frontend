import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/friend_transactions.dart';
import 'package:raven/screens/ride_history.dart';
import 'package:raven/widgets/chat_screen/group_ride_invite.dart';
import 'package:raven/widgets/chat_screen/message_bubble.dart';
import 'package:raven/widgets/chat_screen/timed_chat_invite.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String friendId;

  ChatScreen({required this.conversationId, required this.friendId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _conversationsCollection =
      FirebaseFirestore.instance.collection('conversations');
  late TextEditingController textController;
  late ScrollController scrollController;

  late CollectionReference _messagesCollection;

  String fetchedName = '';

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    textController = new TextEditingController();
    _messagesCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages');
    fetchContactName();
  }

  fetchContactName() async {
    final snapshot = await _userCollection.doc(widget.friendId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    var textToSend = textController.text;
    var timeOfSending = DateTime.now();
    textController.clear();
    await _messagesCollection.add({
      'time': timeOfSending,
      'sender': _auth.currentUser!.uid,
      'text': textToSend,
      'read': false
    });
    await _conversationsCollection
        .doc(widget.conversationId)
        .update({'lastText': textToSend, 'lastTime': timeOfSending});

    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void sendTimedChatInvitation() async {
    await _messagesCollection.add({
      'time': DateTime.now(),
      'sender': _auth.currentUser!.uid,
      'text': '/TIMED_CHAT',
      'status': 'PENDING',
      'read': false
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: theme.primaryColor,
      centerTitle: true,
      title: Text(
        fetchedName,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.primaryColorDark)),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RideHistoryScreen(
                conversationId: widget.conversationId,
              ),
            ));
          },
          icon: Icon(Icons.local_taxi_rounded),
          iconSize: 25,
          color: theme.primaryColorDark,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  FriendTransactionsScreen(friendId: widget.friendId),
            ));
          },
          icon: Icon(Icons.credit_card_rounded),
          iconSize: 25,
          color: theme.primaryColorDark,
        ),
      ],
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_rounded),
        color: theme.primaryColorDark,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appBar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
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
                    stream: _messagesCollection
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      if (snapshot.hasData) {
                        final documents = (snapshot.data)!.docs;
                        return ListView.builder(
                            key: ValueKey(Uuid().v4()),
                            controller: scrollController,
                            reverse: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              if (documents[index]['text'] == '/TIMED_CHAT') {
                                return TimedChatInvite(
                                  conversationId: widget.conversationId,
                                  messageId: documents[index].id,
                                  key: ValueKey(documents[index].id),
                                  sender: documents[index]['sender'],
                                  text: documents[index]['text'],
                                  time: DateTime.parse(documents[index]['time']
                                      .toDate()
                                      .toString()),
                                );
                              } else if (documents[index]['text'] ==
                                  '/GROUP_RIDE_INVITE') {
                                return GroupRideInvite(
                                  conversationId: widget.conversationId,
                                  messageId: documents[index].id,
                                  key: ValueKey(documents[index].id),
                                  sender: documents[index]['sender'],
                                  text: documents[index]['text'],
                                  time: DateTime.parse(documents[index]['time']
                                      .toDate()
                                      .toString()),
                                  originLat: documents[index]['originLat'],
                                  originLng: documents[index]['originLng'],
                                  destinationLat: documents[index]
                                      ['destinationLat'],
                                  destinationLng: documents[index]
                                      ['destinationLng'],
                                  polyline: documents[index]['polyline'],
                                  bounds: documents[index]['bounds'],
                                  destinationPlaceName: documents[index]
                                      ['destinationPlaceName'],
                                  ticketId: documents[index]['ticketId'],
                                );
                              } else {
                                return MessageBubble(
                                  conversationId: widget.conversationId,
                                  messageId: documents[index].id,
                                  key: ValueKey(documents[index].id),
                                  sender: documents[index]['sender'],
                                  text: documents[index]['text'],
                                  time: DateTime.parse(documents[index]['time']
                                      .toDate()
                                      .toString()),
                                  isRead: documents[index]['read'],
                                );
                              }
                            });
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
              child: Row(
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                    onPressed: () => sendTimedChatInvitation(),
                    icon: Icon(Icons.timer_rounded),
                    color: theme.primaryColorDark,
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 15),
                  ),
                  IconButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        sendMessage();
                      }
                    },
                    icon: Icon(Icons.send_rounded),
                    color: theme.primaryColorDark,
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
