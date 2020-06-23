import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/session.dart';

class SessionRow extends StatelessWidget {
  final Session session;

  SessionRow({this.session});

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
                        session.startDate,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ],
                )
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }
}
