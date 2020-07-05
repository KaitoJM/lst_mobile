import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lifesweettreatsordernotes/models/Transaction.dart';

import 'package:lifesweettreatsordernotes/models/user.dart';
import 'package:lifesweettreatsordernotes/requests/transactions.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  int session_id;
  String sessionName;
  double sessionTotal;
  double sessionTotalPaid;
  bool loaded_transaction = false;
  String user_type;
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

  void getUserType() async {
    String type = await UsersData().userType();
    setState(() {
      user_type = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    session_id = data['session_id'];
    sessionName = data['session_name'];
    sessionTotal = data['session_total'].toDouble();
    sessionTotalPaid = data['session_total_paid'].toDouble();
    getData();

    getUserType();

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
      body: (loaded_transaction) ? Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Text('${sessionName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      )
                  ),
                  Text('₱${sessionTotalPaid}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.pinkAccent
                    ),
                  ),
                  Text('/₱${sessionTotal}')
                ],
              ),
            ),
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
                                color: (user.totalAmountToBePaid() == user.totalCashReceived()) ? Colors.green : (user.totalAmountToBePaid() < user.totalCashReceived()) ? Colors.amber : Colors.black26,
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
                                        '₱${transaction.amount}',
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
                      if (user_type == 'finance')
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
                                  if (!user.loadingAddingCash)
                                  OutlineButton.icon(
                                    icon: Icon(Icons.add),
                                    label: Text('Add'),
                                    onPressed: () async {
                                      print(user.cashRecieveAmount);
                                      user.loadingAddingCash = true;
                                      Map res = await TransactionsData().addTransaction(session_id, user.id, user.cashRecieveAmount);
                                      user.loadingAddingCash = false;
                                      if (res['err'] == 0) {
                                        TransactionModel newTransaction = TransactionModel(id: res['id'], session_id: session_id, user_id: user.id, amount: user.cashRecieveAmount,createdDate: res['date']);
                                        setState(() {
                                          user.transactions.add(newTransaction);
                                        });
                                      }
                                    },
                                  ) else SizedBox(
                                    width: 100,
                                    child: SpinKitThreeBounce(
                                      color: Colors.pinkAccent,
                                      size: 15,
                                    ),
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
      ) : Center(
          child: SpinKitDoubleBounce(
            color: Colors.pinkAccent,
            size: 90.0,
          )
      ),
    );
  }
}
