import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/session.dart';

class SessionEndedRow extends StatelessWidget {
  final Session session;
  final Function viewDetails;

  SessionEndedRow({this.session, this.viewDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        child: Row (
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        session.name,
                        style: TextStyle(
                          fontSize: 15,
                        )
                    ),
                    Text(
                        '${session.startDate} to ${session.endDate}',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ],
                )
            ),
            Text('₱${session.total_paid()} / ₱${session.total()}'),
            IconButton(
              onPressed: viewDetails,
              icon: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}
