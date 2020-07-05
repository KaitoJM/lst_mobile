import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/Transaction.dart';

import 'package:lifesweettreatsordernotes/models/user.dart';
import 'package:lifesweettreatsordernotes/requests/transactions.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  int session_id;
  bool loaded_transaction = false;
  List<User> users = List<User>();

  void getData() async {

    if (loaded_transaction == false) {
      List<User> users_temp = await TransactionsData().getTransactions(session_id);
      loaded_transaction = true;
      setState(() {
        users = users_temp;
      });
    }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loaded_transaction = false;
              getData();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text('Test'),
            Expanded(
              child: ListView(
                children: users.map((user) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black26,
                            width: 1,
                            style: BorderStyle.solid
                          )
                        ),
                        child: Row(
                          children: <Widget>[
                            Text('${user.fname} '),
                            Text('${user.lname}'),
                            Text(' - ₱${user.totalAmountToBePaid()}'),
                            Expanded(child: Text('/₱${user.totalAmount()}')),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Text('₱${user.totalCashReceived()}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      if (user.transactions.length > 0)
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.black26,
                                      width: 1,
                                      style: BorderStyle.solid
                                  )
                              ),
                              child: Column(
                                children: user.transactions.map((transaction) {
                                  return Row(
                                    children: <Widget>[
                                      Expanded(child: Text('${transaction.createdDate}')),
                                      Text(
                                        '${transaction.amount}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                color: Colors.black26,
                                width: 1,
                                style: BorderStyle.solid
                                )
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text('Add Payment : ',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 25,
                                    child: TextField(
                                      onChanged: (val) {
                                        user.cashRecieveAmount = double.parse(val);
                                      },
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          height: 1.5,
                                          color: Colors.black
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  OutlineButton.icon(
                                    icon: Icon(Icons.add),
                                    label: Text('Add'),
                                    onPressed: () async {
                                      print(user.cashRecieveAmount);
                                      Map res = await TransactionsData().addTransaction(session_id, user.id, user.cashRecieveAmount);

                                      if (res['err'] == 0) {
//                                        user.transactions.add(
//
//                                        );
                                      }
                                      print(res);
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
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
