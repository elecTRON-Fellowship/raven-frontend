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
    //route arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
                  onPressed: () {},
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
                  child: Icon(
                    Icons.account_circle,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  ((args['name']) as String),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 230, 237, 1.0),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
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
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              color: Color.fromRGBO(212, 230, 237, 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
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
                    onPressed: () {},
                    icon: Icon(Icons.send_rounded),
                    color: Theme.of(context).primaryColorDark,
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 15),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
