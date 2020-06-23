import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.pinkAccent[100],
            child: Column(
              children: <Widget>[
                Image(image: AssetImage('assets/lstlogo.png'))
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
                    Navigator.pushNamed(context, '/sessions');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('My Account'),
                  onTap: (){},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
