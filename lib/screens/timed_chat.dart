import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimedChatScreen extends StatefulWidget {
  const TimedChatScreen({Key? key}) : super(key: key);

  @override
  _TimedChatScreenState createState() => _TimedChatScreenState();
}

class _TimedChatScreenState extends State<TimedChatScreen> {
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

  late int _secondsRemaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _startTimer() {
    _secondsRemaining = 600;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0)
          _secondsRemaining--;
        else {
          _timer.cancel();
          Navigator.of(context).pop();
        }
      });
    });
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
              setState(() {
                _timer.cancel();
              });
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
    var minutes = _secondsRemaining ~/ 60;
    var minutesString = minutes.toString();
    if (minutesString.length == 1) minutesString = '0$minutesString';
    var seconds = _secondsRemaining % 60;
    var secondsString = seconds.toString();
    if (secondsString.length == 1) secondsString = '0$secondsString';

    //route arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
              Center(
                child: Text(
                  '☕ $minutesString:$secondsString',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color.fromRGBO(17, 128, 168, 1.0),
                    ),
                  ),
                ),
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
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: _secondsRemaining / 600,
                      color: Theme.of(context).primaryColorDark,
                      minHeight: 6,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
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
