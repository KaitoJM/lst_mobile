import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/session.dart';

enum rowOption { view, open, edit, remove }

class SessionRow extends StatelessWidget {
  final Session session;
  final Function delete;
  final Function edit;
  final Function open;

  SessionRow({this.session, this.open, this.delete, this.edit});

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
            SizedBox(
                width: 50,
                height: 50,
                child: PopupMenuButton<rowOption>(
                  onSelected: (rowOption result) {
                    if (result == rowOption.open) {
                      open();
                    }
                    if (result == rowOption.edit) {
                      edit();
                    }
                    if (result == rowOption.remove) {
                      delete();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<rowOption>>[
                    const PopupMenuItem<rowOption>(
                      value: rowOption.view,
                      child: Text('View'),
                    ),
                    const PopupMenuItem<rowOption>(
                      value: rowOption.open,
                      child: Text('Open Session'),
                    ),
                    const PopupMenuItem<rowOption>(
                      value: rowOption.edit,
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<rowOption>(
                      value: rowOption.remove,
                      child: Text('Remove'),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
