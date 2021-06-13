import 'package:flutter/material.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_contributor_card.dart';

class MyTicketContributors extends StatelessWidget {
  const MyTicketContributors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 320,
        width: 330,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => MyTicketContributorCard(
            contributorName: 'Zaid Sheikh',
            amountContributed: 300,
            backgroundColor: Theme.of(context).primaryColorLight,
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
