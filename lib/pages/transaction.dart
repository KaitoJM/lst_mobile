import 'package:flutter/material.dart';

import 'package:lifesweettreatsordernotes/models/user.dart';
import 'package:lifesweettreatsordernotes/requests/transactions.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  int session_id;
  List<User> users = List<User>();

  void getData() async {
    List<User> users_temp = await TransactionsData().getTransactions(session_id);

    setState(() {
      users = users_temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    session_id = data['session_id'];
    getData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Money Transactions'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Test'),
            Expanded(
              child: ListView(
                children: users.map((user) {
                  return Row(
                    children: <Widget>[
                      Text('${user.fname}'),
                      Text(' - ${user.totalAmountToBePaid()}')
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
