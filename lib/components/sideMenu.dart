import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: 310,
            height: 228,
            padding: EdgeInsets.fromLTRB(0, 50, 0, 25),
            color: Colors.pinkAccent[100],
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: 150,
                    child: Image(image: AssetImage('assets/lstlogo.png'))
                )
              ],
            )
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: (){
//                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.fastfood),
                  title: Text('Products'),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Sessions'),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/sessions');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.motorcycle),
                  title: Text('Deliveries'),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/deliveries');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline),
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
