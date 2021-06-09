import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationCard extends StatelessWidget {
  final String name;
  final String lastText;
  final int unreadTexts;
  final String time;

  ConversationCard(this.name, this.lastText, this.unreadTexts, this.time);

  void selectConversation(BuildContext context, String name) {
    Navigator.of(context).pushNamed('/chat', arguments: {'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      margin: EdgeInsets.only(bottom: 4, left: 10, right: 10),
      width: double.infinity,
      height: 88,
      child: Card(
        color: Color.fromRGBO(212, 230, 237, 1.0),
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () => selectConversation(context, this.name),
          borderRadius: BorderRadius.circular(15),
          splashColor: Theme.of(context).primaryColorLight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 55,
                  color: Colors.blueGrey,
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
                    this.name,
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
                    child: Text(
                      this.lastText,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 14, color: Colors.grey)),
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
                    Text(
                      this.time,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 14, color: Colors.blueGrey)),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (this.unreadTexts != 0)
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          this.unreadTexts.toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 12, color: Colors.white)),
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
