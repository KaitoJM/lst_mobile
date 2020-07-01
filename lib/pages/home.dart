import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';

// models
import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/models/order.dart';

// requests
import 'package:lifesweettreatsordernotes/requests/sessions.dart';
import 'package:lifesweettreatsordernotes/requests/orders.dart';

//components
import 'package:lifesweettreatsordernotes/components/sideMenu.dart';
import '../components/order_row.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Map data = {};
  Session session;
  bool loading = false;

  void _showDialogCloseSession(int session_id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Close Session"),
          content: new Text("This action will keep this session to history and make it non-editable. \nPlease make sure all orders are paid and set. \nDo you wish to continue?"),
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
                setState(() {
                  loading = true;
                });
                Map responseMap = await SessionsData().CloseSessionResponse(session_id: session_id);

                setState(() {
                  loading = false;
                });


                if (responseMap['err'] == 0) {
                  refreshSession();
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

  void _showDialogOpenSession(int session_id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Open Session"),
          content: new Text("Are you sure to open this session? \nAre all available product's stock already set?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Edit Session"),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/new_session', arguments: {
                  'session': session
                });
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                Map responseMap = await SessionsData().OpenSessionRespose(session_id: session_id);

                setState(() {
                  loading = false;
                });

                if (responseMap['err'] == 0) {
                  refreshSession();
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

  void refreshSession() async {
    setState(() {
      loading = true;
    });
    Session session_refresh = await SessionsData().currentSession();

    setState(() {
      loading = false;
      session.id = session_refresh.id;
      session.orders = session_refresh.orders;
      session.name = session_refresh.name;
      session.startDate = session_refresh.startDate;
      session.products = session_refresh.products;
      session.endDate = session_refresh.endDate;
      session.status = session_refresh.status;
    });
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    session = data['session'];

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: (session.id != null) ? FloatingActionButton(
          onPressed: () async {
            dynamic received = await Navigator.pushNamed(context, '/new_order', arguments: {
              'session_id': session.id,
              'order': null
            });

            refreshSession();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent[100],
        ) : null,
        appBar: AppBar(
          title: Text((session.status == 1) ? 'Today\'s Orders' : (session.status == 0) ? 'Preparation' : 'No Session'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent[100],
          elevation: 0.0,
          actions: <Widget>[
            if(session.status == 0)
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                Navigator.pushNamed(context, '/new_session', arguments: {
                  'session': session
                });

                refreshSession();
              },
            ),
            if(session.status == 1)
              IconButton(
                icon: Icon(Icons.assignment),
                onPressed: (){
                  Navigator.pushNamed(context, '/assignments', arguments: {
                    'session_id': session.id
                  });
                },
              )
          ],
        ),
        drawer: SideMenu(),
        body: (session.id != null) ? Column(
          children: <Widget>[
            if(loading)
            LinearProgressIndicator(
              backgroundColor: Colors.pinkAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
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
                              onPressed: () {
                                if (session.status == 1) {
                                  // to close
                                  _showDialogCloseSession(session.id);
                                } else if (session.status == 0) {
                                  //to open
                                  _showDialogOpenSession(session.id);
                                } else {
                                  _showErrorMessage('Oops!', 'Invalid session.');
                                }
                              },
                              icon: ((session.status == 1) ? Icon(Icons.cancel) : (session.status == 0) ? Icon(Icons.open_in_browser) : Icon(Icons.cancel)),
                              label: Text((session.status == 1) ? 'Close' : (session.status == 0) ? 'Open' : ' --- '),
                            )
                          ],
                        )
                    ),
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: session.products.map((product) {
                          return Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(3),
                                height: 80,
                                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                child: ListView(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text('${product.totalOrderQtyOrdered}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: (session.status == 1) ? 15 : (session.status == 0) ? 30 : 30,
                                              color: Colors.white
                                          ),
                                        ),
                                        if ((session.status == 1) || (product.qty > 0))
                                        Text('/${product.qty}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
//                                    Text(((session.status == 1) || (product.qty > 0)) ? '${product.totalOrderQtyOrdered}/${product.qty}' : (session.status == 0) ? '${product.totalOrderQtyOrdered}' : '',
//                                      style: TextStyle(
//                                          fontWeight: FontWeight.bold,
//                                          fontSize: (session.status == 1) ? 15 : (session.status == 0) ? 30 : 30,
//                                          color: Colors.white
//                                      ),
//                                    ),
                                    Text((session.status == 1) ? '₱${product.totalOrderAmount}' : (session.status == 0) ? '' : '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (session.status == 1) ? 15 : 0,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text('${product.productName}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [
                                      (product.totalOrderQtyOrdered == product.qty) ? Colors.green[300] : (product.totalOrderQtyOrdered > product.qty) ? Colors.pink[300] : Colors.amber[300],
                                      (product.totalOrderQtyOrdered == product.qty) ? Colors.green[600] : (product.totalOrderQtyOrdered > product.qty) ? Colors.pink[600] : Colors.amber[600],
                                      (product.totalOrderQtyOrdered == product.qty) ? Colors.green[600] : (product.totalOrderQtyOrdered > product.qty) ? Colors.pink[600] : Colors.amber[600],
                                      (product.totalOrderQtyOrdered == product.qty) ? Colors.green[300] : (product.totalOrderQtyOrdered > product.qty) ? Colors.pink[300] : Colors.amber[300],
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(0.0, 1.0),
                                  ),
                                  color: (product.totalOrderQtyOrdered == product.qty) ? Colors.green[300] : (product.totalOrderQtyOrdered > product.qty) ? Colors.pink[300] : Colors.amber[300],
                                  boxShadow: [
                                    BoxShadow(color: (product.totalOrderQtyOrdered == product.qty) ? Colors.green : (product.totalOrderQtyOrdered > product.qty) ? Colors.pink : Colors.amber, spreadRadius: 1),
                                  ],
                                ),
                              )
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            refreshSession();
                            return false;
                          },
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: session.orders.map((order) {
                              return Slidable(
                                key: new Key(order.id.toString()),
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  new IconSlideAction(
                                    caption: 'Items',
                                    color: Colors.blue,
                                    icon: Icons.list,
                                    onTap: () {
                                      OpenDialog(order);
                                    },
                                  ),
                                  if (session.status == 1)
                                    IconSlideAction(
                                      caption: (order.status == 0) ? 'Paid' : 'Unpaid',
                                      color: Colors.indigo,
                                      icon: (order.status == 0) ? Icons.check : Icons.close,
                                      onTap: () async {
                                        if (order.status == 0) {
                                          Map response = await OrdersData().payOrderResponse(order.id);
                                          if (response['err'] == 0) {
                                            setState(() {
                                              session.orders[session.orders.indexOf(order)].status = 1;
                                            });
                                          } else {
                                            _showErrorMessage('Woah!', response['msg']);
                                          }
                                        } else if(order.status == 1) {
                                          Map response = await OrdersData().unpayOrderResponse(order.id);
                                          if (response['err'] == 0) {
                                            setState(() {
                                              session.orders[session.orders.indexOf(order)].status = 0;
                                            });
                                          } else {
                                            _showErrorMessage('Woah!', response['msg']);
                                          }
                                        }
                                      },
                                    ),
                                ],
                                secondaryActions: <Widget>[
                                  new IconSlideAction(
                                    caption: 'Edit',
                                    color: Colors.black45,
                                    icon: Icons.edit,
                                    onTap: () async {
                                      dynamic received = await Navigator.pushNamed(context, '/edit_order', arguments: {
                                        'session_id': session.id,
                                        'order_id': order.id,
                                        'customer_name': '${order.customerFName} ${order.customerLName}',
                                        'order_items': jsonEncode(order.items)
                                      });

                                      refreshSession();
                                    },
                                  ),
                                  new IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () async {
//                                bool del = await deleteConfirmation();
                                      //                          if (del) {
                                      Map responseMap = await OrdersData().deleteOrderResponse(order_id: order.id);

                                      if (responseMap['err'] == 0) {
                                        setState(() {
                                          session.orders.remove(order);
                                        });
                                      } else {
                                        _showErrorMessage('Woah!', responseMap['msg']);
                                      }
                                      //                          }
                                    },
                                  ),
                                ],
                                child: OrderRow(
                                  order: order,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text('TOTAL :'),
                        SizedBox(width: 10),
                        if (session.status == 1)
                          Text(
                            '₱${session.total_paid().toString()} ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.pinkAccent[100]
                            ),
                          ),
                        if (session.status == 1)
                          Text('/',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),),
                        Text(
                          '₱${session.total().toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: (session.status == 1) ? 15 : 20
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        )
        : Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error_outline, size: 150, color: Colors.pink[100]),
                  Text('There are no session to be displayed\nat the moment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/new_session');
                      refreshSession();
                    },
                    child: Text('Add new session',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    color: Colors.pinkAccent[100],
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}