import 'package:flutter/material.dart';
import '../components/order_row.dart';

import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/models/order.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Map data = {};
  Session session;

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
          onPressed: (){
            Navigator.pushNamed(context, '/new_order', arguments: {
              'session_id': session.id,
              'order': null
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent[100],
        ),
        appBar: AppBar(
          title: Text('Today\'s Orders'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent[100],
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(
                  (session.name != null) ? session.name : '',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54
                  ),
                ),
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
                        delete: () {
                          setState(() {
                            session.orders.remove(order);
                          });
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