import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:lifesweettreatsordernotes/models/product.dart';
import 'dart:convert';
import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/components/session_row.dart';
import 'package:lifesweettreatsordernotes/components/session_ended_row.dart';
import 'package:lifesweettreatsordernotes/functions/fetchCurrentSession.dart';
import 'package:lifesweettreatsordernotes/models/order.dart';

import 'package:lifesweettreatsordernotes/globals.dart';
import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';

class SessionList extends StatefulWidget {
  @override
  _SessionListState createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  List<Session> sPending = [];
  List<Session> sEnded = [];
  Session sCurrent = Session(name: '', startDate: '', endDate: '', orders: List<Order>());

  void getData() async {
    sCurrent = await new FetchCurrentSession().getData(current_recommended: true);
    setState(() {
      sCurrent.orders = sCurrent.orders;
    });

    Response response = await get('${global.api_url}get-sessions');
    Map sessions_map = json.decode(response.body);

    List<dynamic> sessionPending = sessions_map['preparation'];
    List<dynamic> sessionEnded = sessions_map['ended'];

    print(sessionPending);
    print(sessionEnded  );

    List<dynamic> sessionPendingLists = sessionPending;
    List<dynamic> sessionEndedLists = sessionEnded;

    setState(() {
      sPending.clear();
      sessionPendingLists.forEach((element) {
        List<SessionProduct> products = List<SessionProduct>();
        List<dynamic> prodList = element['products'];

        prodList.forEach((prod) {
          products.add(
            SessionProduct(
              id: prod['id'],
              productName: prod['product'],
              price: prod['price'].toDouble(),
              productId: prod['product_id'],
              qty: (prod['qty'] != null) ? prod['qty'] : 0
            )
          );
        });

        sPending.add(
            Session(
                id: element['id'],
                name: element['name'],
                startDate: element['start_date'],
                endDate: element['end_date'],
                status: element['status'],
                products: products
            )
        );
      });

      sEnded.clear();
      sessionEndedLists.forEach((element) {
        sEnded.add(
            Session(
                id: element['id'],
                name: element['name'],
                startDate: element['start_date'],
                endDate: element['end_date'],
                status: element['status']
            )
        );
      });
    });
  }

  Future<void> _showErrorMessage(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(int session_id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Close Session"),
          content: new Text("Are you sure to close this session? \nAre all orders paid already?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes Continue!"),
              onPressed: () async {
                Response response = await post('${global.api_url}close-session',
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'session_id': session_id
                    })
                );

                Map responseMap = json.decode(response.body);
                print(responseMap);

                if (responseMap['err'] == 0) {
                  getData();
                } else {
                  _showErrorMessage('Woah!', responseMap['msg']);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget totalAmount(List<Order> orders) {
    double total = 0;

    orders.forEach((element) {
      total += element.total;
    });

    return Text(
      total.toString(),
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic received = await Navigator.pushNamed(context, '/new_session');
          getData();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent[100],
      ),
      appBar: AppBar(
        title: Text('Sessions'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Card(
                color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ((sCurrent.name == '') || (sCurrent.name == null)) ? 'No Open Sessions \nat the Moment' : sCurrent.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(sCurrent.startDate),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text('TOTAL SELL: '),
                                SizedBox(width: 5),
                                totalAmount(sCurrent.orders)
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          OutlineButton.icon(
                            onPressed: (){
                              if (sCurrent.id != null) {
                                _showDialog(sCurrent.id);
                              } else {
                                _showErrorMessage('Oops!', 'Open sessions are empty!');
                              }

                            },
                            icon: Icon(Icons.cancel, color: Colors.white),
                            label: Text('Close',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.white
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.chevron_right, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('PREPARATIONS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Chip(
                        label: Text(
                          '${sPending.length.toString()}',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        backgroundColor: Colors.pinkAccent[100],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: sPending.map((session) {
                  return SessionRow (
                    session: session,
                    delete: () async {
                      Response response = await post('${global.api_url}delete-session',
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, dynamic>{
                            'session_id': session.id
                          })
                      );

                      Map responseMap = json.decode(response.body);
                      print(responseMap);

                      if (responseMap['err'] == 0) {
                        setState(() {
                          sPending.remove(session);
                        });
                      } else {
                        _showErrorMessage('Woah!', responseMap['msg']);
                      }
                    },
                    edit:() {
                      Navigator.pushNamed(context, '/new_session', arguments: {
                        'session': session
                      });
                    },
                    open: () async {
                      if (sCurrent.id == null) {
                        Response response = await post('${global.api_url}open-session',
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, dynamic>{
                              'session_id': session.id
                            })
                        );

                        Map responseMap = json.decode(response.body);
                        print(responseMap);

                        if (responseMap['err'] == 0) {
                          getData();
                        } else {
                          _showErrorMessage('Woah!', responseMap['msg']);
                        }
                      } else {
                        _showErrorMessage('Oops!', 'Are you planning to open up multiple session at once? \n\nYou still have an open session left. \nPlease close all open session first to continue.');
                      }
                    }
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('HISTORY',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Chip(
                        label: Text(
                          ' ${sEnded.length.toString()} ',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        backgroundColor: Colors.pinkAccent[100],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: sEnded.map((session) {
                    return SessionEndedRow(session: session);
                  }).toList(),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
