import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatelessWidget {
  // const ChatScreen({ Key? key }) : super(key: key);

  final List<Map<String, Object>> _messages = [
    {
      'type': 'received',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'received',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'sent',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'received',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'sent',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'sent',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'received',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'received',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'sent',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'received',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'sent',
      'text': 'wassup',
      'time': '13:15',
    },
    {
      'type': 'sent',
      'text': 'wassup',
      'time': '13:15',
    },
  ];

  _buildMessage(Map<String, Object> message, BuildContext context) {
    bool isSent = message['type'] == 'sent';
    return Container(
      margin: isSent
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      decoration: BoxDecoration(
        color: isSent
            ? Color.fromRGBO(103, 186, 216, 1.0)
            : Color.fromRGBO(194, 222, 232, 1.0),
        borderRadius: isSent
            ? BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (message['time'] as String),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: Colors.grey[800])),
            ),
            Text(
              (message['text'] as String),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(103, 186, 216, 1.0),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search_rounded),
                iconSize: 30,
                color: Theme.of(context).primaryColor,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_rounded),
                  iconSize: 34.5,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Icon(
                  Icons.account_circle,
                  size: 55,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                'Mizan Ali',
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black)),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Colors.white,
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
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  itemCount: _messages.length,
                  itemBuilder: (ctx, index) {
                    Map<String, Object> message = _messages[index];
                    return _buildMessage(message, context);
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            color: Colors.white,
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write your message here...',
                      fillColor: Color.fromRGBO(194, 222, 232, 1.0),
                      filled: true,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send_rounded),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
