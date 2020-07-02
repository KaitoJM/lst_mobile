import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/requests/sessions.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';

class HistoryDetails extends StatefulWidget {
  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
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
        title: Text((session.name != null) ? '${session.name}' : ''),
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () async {
              if (user_id == null) {
                user_id = await UsersData().userId();
              } else {
                user_id = null;
              }

              setState(() {
                loading = true;
              });

              Session temp = await SessionsData().getSessionByProduct(session_id, user_id);
              setState(() {
                loading = false;
                session = temp;
                loaded_session = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                loading = true;
              });

              Session temp = await SessionsData().getSessionByProduct(session_id, user_id);
              setState(() {
                loading = false;
                session = temp;
                loaded_session = true;
              });
            },
          ),
        ],
      ),
      body: (session.id != null) ? Column(
        children: <Widget>[
          if(loading)
          LinearProgressIndicator(
            backgroundColor: Colors.pinkAccent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('${session.startDate} to ${session.endDate}'),
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
                        Row(
                          children: <Widget>[
                            Text('EXPENSE:'),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text('₱${session.expense}',
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
                        Row(
                          children: <Widget>[
                            Text('PROFIT:'),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text('₱${session.total_paid() - session.expense}',
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
                                    Text('${item.qty} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17
                                      ),
                                    ),
                                    Text('${item.order.customerFName} '),
                                    Text('${item.order.customerLName} '),
                                    Text('x ${item.price} '),
                                    if (item.order.status == 1)
                                      Text('(Paid)',
                                        style: TextStyle(
                                            color: Colors.amber
                                        ),
                                      ),
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
          ),
        ],
      ) : Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.cloud_download, size: 150, color: Colors.pink[100]),
              Text('Loading Session...',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
