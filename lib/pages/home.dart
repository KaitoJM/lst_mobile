import 'package:flutter/material.dart';
import '../components/order_row.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/models/order.dart';

import 'package:lifesweettreatsordernotes/functions/fetchCurrentSession.dart';
import 'package:lifesweettreatsordernotes/components/sideMenu.dart';
import 'package:lifesweettreatsordernotes/globals.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Map data = {};
  Session session;


  Future<bool> deleteConfirmation() async {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Confirmation"),
          content: new Text("Canceling will remove the selected order. \nDo you wish to continue?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("NO"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text("PROCEED"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
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

  Future<void> OpenDialog(Order order) async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${order.customerFName} ${order.customerLName}',
                            style: TextStyle(
                                fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          '${order.total}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: order.items.map((item) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${item.qty}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 7,child: Text(item.productName)),
                                  Expanded(flex: 2,child: Text('${item.price}')),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${item.total}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }
    )) {

    }
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
          fontSize: 20
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    session = data['session'];

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            dynamic received = await Navigator.pushNamed(context, '/new_order', arguments: {
              'session_id': session.id,
              'order': null
            });

            Session session_refresh = await new FetchCurrentSession().getData();

            setState(() {
              session.orders = session_refresh.orders;
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent[100],
        ),
        appBar: AppBar(
          title: Text((session.status == 1) ? 'Today\'s Orders' : (session.status == 0) ? 'Pending Session' : 'No Current Session'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent[100],
          elevation: 0.0,
        ),
        drawer: SideMenu(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      (session.name != null) ? session.name : '',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54
                      ),
                    ),
                    OutlineButton.icon(
                        onPressed: () {},
                        icon: ((session.status == 1) ? Icon(Icons.cancel) : (session.status == 0) ? Icon(Icons.open_in_browser) : Icon(Icons.cancel)),
                        label: Text((session.status == 1) ? 'Close' : (session.status == 0) ? 'Open' : ' --- '),
                    )
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: (){},
                      child: Text('All',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                      color: Colors.pinkAccent,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      onPressed: (){},
                      child: Text('Mango'),
                      color: Colors.amber,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      onPressed: (){},
                      child: Text('Choco'),
                      color: Colors.amber,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FlatButton(
                      onPressed: (){},
                      child: Text('Graham'),
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20,
                color: Colors.grey,
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: session.orders.map((order) {
                      return OrderRow(
                        order: order,
                        edit: () async {

                          dynamic received = await Navigator.pushNamed(context, '/edit_order', arguments: {
                            'session_id': session.id,
                            'order_id': order.id,
                            'customer_name': '${order.customerFName} ${order.customerLName}',
                            'order_items': jsonEncode(order.items)
                          });

                          Session session_refresh = await new FetchCurrentSession().getData();

                          setState(() {
                            session.orders = session_refresh.orders;
                          });
                        },
                        delete: () async {
//                          bool del = await deleteConfirmation();
//                          if (del) {
                            Response response = await post('${global.api_url}delete-order',
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                                body: jsonEncode(<String, dynamic>{
                                  'order_id': order.id
                                })
                            );

                            Map responseMap = json.decode(response.body);
                            print(responseMap);

                            if (responseMap['err'] == 0) {
                              setState(() {
                                session.orders.remove(order);
                              });
                            } else {
                              _showErrorMessage('Woah!', responseMap['msg']);
                            }

//                          }
                        },
                        openDetails: () {
                          OpenDialog(order);
                        }
                      );
                    }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('TOTAL :'),
                  SizedBox(width: 10),
                  totalAmount(session.orders)
                ],
              )
            ],
          ),
        )
    );
  }
}