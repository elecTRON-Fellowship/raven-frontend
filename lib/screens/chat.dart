import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/friend_transactions.dart';
import 'package:raven/screens/timed_chat.dart';
import 'package:raven/widgets/chat_screen.dart/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  // const ChatScreen({ Key? key }) : super(key: key);

  String conversationId;
  String friendId;

  ChatScreen({required this.conversationId, required this.friendId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController textController = new TextEditingController();
  final ScrollController scrollController = ScrollController();

  late CollectionReference _messagesCollection;

  String fetchedName = '';

  @override
  void initState() {
    super.initState();
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
    await _messagesCollection.add({
      'time': DateTime.now(),
      'sender': _auth.currentUser!.uid,
      'text': textController.text,
    });
    textController.clear();
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          fetchedName,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: theme.primaryColorDark)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.credit_card_rounded),
            iconSize: 30,
            color: theme.primaryColorDark,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.all(15),
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
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        final documents = (snapshot.data)!.docs;
                        return ListView.builder(
                          controller: scrollController,
                          reverse: true,
                          itemCount: documents.length,
                          itemBuilder: (context, index) => MessageBubble(
                            ValueKey(documents[index].id),
                            documents[index]['sender'],
                            documents[index]['text'],
                            DateTime.parse(
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
              child: Row(
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
                        contentPadding: EdgeInsets.all(13),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
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
                    color: theme.accentColor,
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 15),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TimedChatScreen(
                            conversationId: widget.conversationId,
                            friendName: fetchedName,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.timer_rounded),
                    color: theme.accentColor,
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
