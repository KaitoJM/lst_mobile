import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/globals.dart';
import 'package:lifesweettreatsordernotes/requests/transactions.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  String user_name = '';
  String user_photo = '';
  double cashInHand = 0;
  double cashInBank = 0;
  bool loaded = false;

  void getUser() async {
    String user_name_temp = await UsersData().userName();
    String user_photo_temp = await UsersData().userPhoto();

    setState(() {
      user_name = user_name_temp;
      user_photo = user_photo_temp;
    });
  }

  void getMoney() async {
    if (!loaded ){
      Map money = await TransactionsData().getTotalMoney();

      setState(() {
        cashInHand = money['cash_on_hand'].toDouble();
        cashInBank = money['cash_on_bank'].toDouble();
        loaded = true;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    getMoney();

    return Drawer(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: 310,
                height: 260,
                padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Colors.pinkAccent[100],
                      Colors.pinkAccent,
                    ]
                  )
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: SizedBox(
                    width: 130,
                    child: Image(image: AssetImage('assets/lstlogo.png'))
                ),
              ),
              Positioned(
                top: 50,
                left: 15,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black87
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                      SizedBox(width: 10),
                      Text('₱${cashInHand}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: 15,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black54
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.account_balance, color: Colors.white),
                      SizedBox(width: 10),
                      Text('₱${cashInBank}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black26
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new NetworkImage('${global.user_photo_url}${user_photo}')
                              )
                          )
                      ),
                      SizedBox(width: 10),
                      Text(user_name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: Colors.pink),
                  title: Text('Home'),
                  onTap: (){
//                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.fastfood, color: Colors.pink),
                  title: Text('Products'),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/products');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.pink),
                  title: Text('Sessions'),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/sessions');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.pink),
                  title: Text('Customers'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/customers');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.motorcycle, color: Colors.pink),
                  title: Text('Deliveries'),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/deliveries');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.pink),
                  title: Text('Logout'),
                  onTap: () async {
                    Navigator.pop(context);
                    await UsersData().logOut();
                    Navigator.pushReplacementNamed(context, '/loading');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
