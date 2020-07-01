import 'package:flutter/material.dart';

import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/requests/orders.dart';
import 'package:lifesweettreatsordernotes/requests/sessions.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class Assignments extends StatefulWidget {
  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  int session_id;
  int user_id;
  bool loading = false;

  Map data;
  Session session = Session();
  bool loaded_session = false;

  void setSession() async {
    if (!loaded_session) {
      setState(() {
        loading = true;
      });

      user_id = await UsersData().userId();
      Session temp = await SessionsData().getSessionByProduct(session_id, user_id);
      setState(() {
        loading = false;
        session = temp;
        loaded_session = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
//    print(data);
    session_id = data['session_id'];
    setSession();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Assignments'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: (session.id != null) ? Column(
        children: <Widget>[
          if(loading)
            LinearProgressIndicator(
              backgroundColor: Colors.greenAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column (
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Text('${session.name}'),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('₱${session.total_paid()}',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pinkAccent
                                ),
                              ),
                              Text('/₱${session.total()}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: session.products.map((product) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('${product.productName}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text('₱${product.totalPaid()}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pinkAccent
                                        ),
                                      ),
                                      Text('/₱${product.total()}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: product.orderItems.map((item) {
                                return Row(
                                  children: <Widget>[
                                    SizedBox(width: 15),
                                    (item.loading) ?
                                    SizedBox(
                                      width: 24,
                                      child: SpinKitRing(
                                        color: Colors.green,
                                        size: 18.0,
                                        lineWidth: 2,
                                      ),
                                    ) :
                                    GestureDetector(
                                      child: Icon((item.order.status == 1) ? Icons.check_box : Icons.check_box_outline_blank,
                                        color: Colors.green[200],
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          loading = true;
                                          item.loading = true;
                                        });

                                        if (item.order.status == 1) {
                                          Map response = await OrdersData().unpayOrderResponse(item.order.id);
                                          if (response['err'] == 0) {
                                            setState(() {
                                              item.order.status = 0;
                                            });
                                          }
                                        } else {
                                          Map response = await OrdersData().payOrderResponse(item.order.id);
                                          if (response['err'] == 0) {
                                            setState(() {
                                              item.order.status = 1;
                                            });
                                          }
                                        }

                                        setState(() {
                                          loading = false;
                                          item.loading = false;
                                        });
                                      },
                                    ),
                                    Text('${item.qty} ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17
                                      ),
                                    ),
                                    Text('${item.order.customerFName} '),
                                    Text('${item.order.customerLName} '),
                                    Text('x ${item.price} '),
                                    Expanded(
                                      child: Text('₱${item.totalComuted()} ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 15)
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ) : Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitDoubleBounce(
                color: Colors.green[100],
                size: 90.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}