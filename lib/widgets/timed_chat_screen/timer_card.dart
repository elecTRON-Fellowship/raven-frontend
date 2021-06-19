import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class TimerCard extends StatefulWidget {
  Function onTimerFinish;

  TimerCard({required this.onTimerFinish});

  @override
  _TimerCardState createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  late int _secondsRemaining;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() async {
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
          widget.onTimerFinish();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var minutes = _secondsRemaining ~/ 60;
    var minutesString = minutes.toString();
    if (minutesString.length == 1) minutesString = '0$minutesString';
    var seconds = _secondsRemaining % 60;
    var secondsString = seconds.toString();
    if (secondsString.length == 1) secondsString = '0$secondsString';

    return Column(
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
        SizedBox(
          height: 10,
        ),
        LinearProgressIndicator(
          value: _secondsRemaining / 600,
          color: Theme.of(context).primaryColorDark,
          backgroundColor: Theme.of(context).backgroundColor,
          minHeight: 6,
        ),
      ],
    );
  }
}
