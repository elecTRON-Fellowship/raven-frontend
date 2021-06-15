import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/contacts_screen.dart/contact_card.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];

  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }

  void fetchContacts() async {
    Iterable<Contact> contactsIterable =
        await ContactsService.getContacts(withThumbnails: false);

    List<Contact> _contacts = contactsIterable.toList();

    List<Contact> _validContacts = _contacts
        .where((item) =>
            item.displayName!.isNotEmpty &&
            item.phones!.length > 0 &&
            item.phones!.elementAt(0).value!.length >= 10)
        .toList();

    setState(() {
      contacts = _validContacts;
    });
  }

  void filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);

    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName!.toLowerCase();

        return contactName.contains(searchTerm);
      });

      setState(() {
        filteredContacts = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_rounded),
                iconSize: 30,
                color: Theme.of(context).primaryColorDark,
              ),
              elevation: 0.0,
              backgroundColor: Theme.of(context).primaryColorLight,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Text(
                'Contacts',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => fetchContacts(),
                  icon: Icon(Icons.sync_rounded),
                  iconSize: 30,
                  color: Theme.of(context).primaryColorDark,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: searchController,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(),
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  fillColor: Theme.of(context).backgroundColor,
                  filled: true,
                  contentPadding: EdgeInsets.all(13),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  labelText: "Search",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            SizedBox(
              height: 10,
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
                    padding: EdgeInsets.all(10),
                    itemCount: searchController.text.isEmpty
                        ? contacts.length
                        : filteredContacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = searchController.text.isEmpty
                          ? contacts[index]
                          : filteredContacts[index];
                      String name = contact.displayName as String;
                      String number =
                          contact.phones!.elementAt(0).value as String;
                      String initials = contact.initials();
                      return ContactCard(
                          name: name, number: number, initials: initials);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}