import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/close_friends.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({Key? key}) : super(key: key);

  @override
  _EndDrawerState createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        child: Drawer(
          elevation: 3.0,
          child: ListView(
            padding: EdgeInsets.only(left: 13, top: 30),
            children: [
              ListTile(
                title: Text(
                  'Raven',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          color: Theme.of(context).primaryColorDark)),
                ),
              ),
              SizedBox(
                height: 38,
              ),
              ListTile(
                title: Text(
                  'Wallet',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Account',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Themes',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Close friends',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CloseFriendsScreen(),
                  ));
                },
              ),
              ListTile(
                title: Text(
                  'Invite a friend',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Log out',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Theme.of(context).primaryColor)),
                ),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/auth', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
