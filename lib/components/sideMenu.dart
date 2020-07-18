import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/globals.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  String user_name = '';
  String user_photo = '';

  void getUser() async {
    String user_name_temp = await UsersData().userName();
    String user_photo_temp = await UsersData().userPhoto();

    setState(() {
      user_name = user_name_temp;
      user_photo = user_photo_temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: 310,
            height: 260,
            padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: SizedBox(
                      width: 150,
                      child: Image(image: AssetImage('assets/lstlogo.png'))
                  ),
                ),
                SizedBox(height: 10),
                Container(
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
                )
              ],
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
