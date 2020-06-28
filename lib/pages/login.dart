import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  String message;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal:40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 180,
                    child: Image.asset('assets/lstlogo.png')
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (val) {
                    email = val;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (val) {
                    password = val;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: (loading) ? SpinKitThreeBounce(
                      color: Colors.pinkAccent,
                      size: 30.0,
                    ) : RaisedButton.icon(
                    color: Colors.pinkAccent[100],
                    onPressed: () async {
                      setState(() {
                        loading = true;
                        message = null;
                      });
                      Map response = await UsersData().login(email, password);
                      setState(() {
                        loading = false;
                      });
                      print(response);
                      if ((response['err'] == 0) && (response['user_id'] != 0)) {
                        SharedPreferences.setMockInitialValues({});
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt('user_id', response['user_id']);
                        print('saved ${response['user_id']}');

                        message = null;
                        Navigator.pushReplacementNamed(context, '/loading');
                      } else {
                        setState(() {
//                          email = '';
//                          password = '';
                          message = response['msg'];
                        });
                      }
                    },
                    label: Text('Login',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    icon: Icon(Icons.present_to_all, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                if (message != null)
                  Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
