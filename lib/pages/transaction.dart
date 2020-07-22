import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lifesweettreatsordernotes/models/Transaction.dart';

import 'package:lifesweettreatsordernotes/models/user.dart';
import 'package:lifesweettreatsordernotes/requests/transactions.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    setState(() {
      loaded_transaction = false;
    });

    List<User> users_temp = await TransactionsData().getTransactions(session_id);
    print(loaded_transaction);

    setState(() {
      loaded_transaction = true;
      users = users_temp;
    });
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
    setState(() {
      session_id = data['session_id'];
      sessionName = data['session_name'];
      sessionTotal = data['session_total'].toDouble();
      sessionTotalPaid = data['session_total_paid'].toDouble();
    });

    if (loaded_transaction == false) {
      getData();
      getUserType();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Money Transactions'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                loaded_transaction = false;
              });
              getData();
            },
          )
        ],
      ),
      body: (loaded_transaction) ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.pinkAccent[100],
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
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
                padding: EdgeInsets.all(15),
                children: users.map((user) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.pinkAccent[400],
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 10),
                      ],
                    ),
                    child: Column(
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
                            ),
                            color: Colors.black54
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text('${user.fname} ${user.lname}', style: TextStyle(color: Colors.white)),
                                    SizedBox(height: 5),
                                    Text('₱${user.totalAmountToBePaid()}/₱${user.totalAmount()}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
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
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black26,
                                        width: 1,
                                        style: BorderStyle.solid
                                    )
                                ),
                                child: Column(
                                  children: user.transactions.map((transaction) {
                                    return Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: (user.transactions.indexOf(transaction) < user.transactions.length - 1) ? BoxDecoration(
                                            border: Border(bottom: BorderSide(width: 1, color: Colors.black26))
                                          ) : null,
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                child: Icon((transaction.payType) ? Icons.account_balance : Icons.account_balance_wallet, color: Colors.lightBlueAccent),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(child: Text('${transaction.createdDate}', style: TextStyle(color: Colors.white))),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Text(
                                                  '₱${transaction.amount}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        if (user_type == 'finance')
                                        Positioned(
                                          top: 7,
                                          right: -15,
                                          child: GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:BorderRadius.circular(20),
                                                  color: Colors.pink,
                                                  border: Border.all(width: 1, color: Colors.black, style: BorderStyle.solid)
                                              ),
                                              height: 20,
                                              width: 20,
                                              child: Icon(Icons.clear, color: Colors.white, size: 15,),
                                            ),
                                            onTap: () async {;
                                              Map result = await TransactionsData().removeTransaction(transaction.id);

                                              if (result['err'] == 0) {
                                                setState(() {
                                                  user.transactions.removeAt(user.transactions.indexOf(transaction));
                                                });
//                                                SnackBar(content: Text('1 transaction has been removed.'));
                                              } else {
//                                                SnackBar(content: Text(result['msg'].toString()));
                                              }
                                            },
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
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 1,
                                    style: BorderStyle.solid
                                  ),
                                  color: Colors.black54,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text('Cash-in : ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 50,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: (user.pay_bank) ? Colors.amber : Colors.white, width: 1, style: BorderStyle.solid),
                                              borderRadius: BorderRadius.circular(5),
                                              color: (user.pay_bank) ? Colors.amber[400] : Colors.transparent
                                            ),
                                            child: GestureDetector(
                                              child: Icon(
                                                Icons.credit_card,
                                                color: (user.pay_bank) ? Colors.white : Colors.white,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  user.pay_bank = !user.pay_bank;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: SizedBox(
                                            width: 60,
                                            height: 25,
                                            child: TextField(
                                              onChanged: (val) {
                                                user.cashRecieveAmount = double.parse(val);
                                              },
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  height: 1.5,
                                                  color: Colors.white
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        if (!user.loadingAddingCash)
                                        OutlineButton.icon(
                                          icon: Icon(Icons.add, color: Colors.white),
                                          label: Text((user.pay_bank) ? 'Bank' : 'Cash', style: TextStyle(color: Colors.white)),
                                          onPressed: () async {
                                            print(user.cashRecieveAmount);
                                            user.loadingAddingCash = true;
                                            Map res = await TransactionsData().addTransaction(session_id, user.id, user.cashRecieveAmount, user.pay_bank);
                                            user.loadingAddingCash = false;
                                            if (res['err'] == 0) {
                                              TransactionModel newTransaction = TransactionModel(id: res['id'], session_id: session_id, user_id: user.id, amount: user.cashRecieveAmount,payType: user.pay_bank,createdDate: res['date']);
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
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
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
