import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/chat_screen.dart/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  // const ChatScreen({ Key? key }) : super(key: key);

  String conversationId;
  String friendName;

  ChatScreen({required this.conversationId, required this.friendName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController textController = new TextEditingController();
  final ScrollController scrollController = ScrollController();

  late CollectionReference _messagesCollection;

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
  void initState() {
    super.initState();
    _messagesCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_rounded),
                iconSize: 30,
                color: Color.fromRGBO(17, 128, 168, 1.0),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/friend-transactions',
                        arguments: {'friendName': widget.friendName});
                  },
                  icon: Icon(Icons.credit_card_rounded),
                  iconSize: 30,
                  color: Color.fromRGBO(17, 128, 168, 1.0),
                )
              ],
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    child: Text(
                      this.widget.friendName.isNotEmpty
                          ? this
                              .widget
                              .friendName
                              .trim()
                              .split(' ')
                              .map((l) => l[0])
                              .take(2)
                              .join()
                          : '',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      )),
                    ),
                    radius: 30,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  widget.friendName,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/timed-chat',
                          arguments: {'name': widget.friendName});
                    },
                    icon: Icon(Icons.timer_rounded),
                    color: Theme.of(context).primaryColorDark,
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
