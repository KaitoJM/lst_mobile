import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/Transaction.dart';
import 'package:lifesweettreatsordernotes/requests/transactions.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Money extends StatefulWidget {
  @override
  _MoneyState createState() => _MoneyState();
}

class _MoneyState extends State<Money> {
  bool loadedTransactions = false;
  List<TransactionModel> transactions = List<TransactionModel>();
  bool openform = false;
  TransactionModel form = TransactionModel(payType: false, direction: 'cash-in');
  String user_type;

  void loadTransaction({String transaction = ''}) async {
    setState(() {
      loadedTransactions = false;
    });

    transactions = await TransactionsData().getMoneyTransactions(transaction: transaction);

    setState(() {
      transactions = transactions;
      loadedTransactions = true;
    });
  }

  void getUserType() async {
    String type = await UsersData().userType();
    print(type);
    setState(() {
      user_type = type;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTransaction();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0.0,
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.pinkAccent[100]
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        loadTransaction();
                      },
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent[100],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
                        ),
                        child: Text('All', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        loadTransaction(transaction: 'cash-in');
                      },
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent[100],
                          border: Border(right: BorderSide(width: 1, color: Colors.pink[300], style: BorderStyle.solid), left: BorderSide(width: 1, color: Colors.pink[300], style: BorderStyle.solid)),
                        ),
                        child: Text('Cash-in', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        loadTransaction(transaction: 'cash-out');
                      },
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent[100],
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))
                        ),
                        child: Text('Cash-out', textAlign: TextAlign.center ,style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    if (user_type == 'finance')
                    SizedBox(width: 10),
                    if (user_type == 'finance')
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          openform = true;
                        });
                      },
                      child: Icon(Icons.add),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 15),
                (loadedTransactions) ?
                Expanded(
                  child: ListView(
                    children: transactions.map((transaction) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (transaction.direction == 'cash-in') ? Colors.green : Colors.amber
                              ),
                              padding: EdgeInsets.all(3),
                              child: Icon(
                                (transaction.direction == 'cash-in') ? Icons.file_download : Icons.file_upload,
                                size: 16,
                                color: (transaction.direction == 'cash-in') ?  Colors.white : Colors.black54
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${transaction.createdDate}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                                Text((transaction.payType) ? 'Bank' : 'Cash',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: Text(
                                '₱${transaction.amount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white
                                ),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ) :
                Expanded(
                  child: Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.white,
                      size: 90.0,
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeOut,
            bottom: (openform) ? 15 : -320,
            left: 10,
            child: Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: (openform) ? 5 : 0, sigmaY: (openform) ? 5 : 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(240, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 10),
                      ],
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (form.direction == 'cash-out') {
                                  setState(() {
                                    form.direction = 'cash-in';
                                  });
                                } else {
                                  setState(() {
                                    form.direction = 'cash-out';
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (form.direction == 'cash-out') ? Colors.red : Colors.green[500],
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(5),
                                child: Icon((form.direction == 'cash-out') ? Icons.file_upload : Icons.file_download),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text((form.direction == 'cash-out') ? 'CASH-OUT' : 'CASH-IN', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (!form.payType) {
                                  setState(() {
                                    form.payType = true;
                                  });
                                } else {
                                  setState(() {
                                    form.payType = false;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: EdgeInsets.all(5),
                                child: (!form.payType) ? Icon(Icons.account_balance_wallet) : Icon(Icons.account_balance),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text((!form.payType) ? 'CASH' : 'BANK', style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ))
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Center(
                            child: Text('AMOUNT'),
                          ),
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          decoration: new InputDecoration(
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10),
                              borderSide: new BorderSide(
                                color: Colors.pink,
                              ),
                            ),
                            //fillColor: Colors.green
                          ),
                          onChanged: (val) {
                            this.form.amount = double.parse(val);
                          },
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.pinkAccent,
                            onPressed: () async {
                              Map result = await TransactionsData().transaction(this.form.amount, this.form.direction, this.form.payType);

                              if (result['err'] == 0) {
                                loadTransaction();
                                setState(() {
                                  openform = false;
                                });
                              }
                            },
                            child: Text('ADD', style: TextStyle(
                              color: Colors.white
                            ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -18,
                  child: Container(
                    width: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          openform = false;
                        });
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Icon(Icons.clear, color: Colors.white)
                    ),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.pink,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 10),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
