import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lifesweettreatsordernotes/requests/users.dart';

import 'package:lifesweettreatsordernotes/models/session.dart';

import 'package:lifesweettreatsordernotes/requests/sessions.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Session session;

  void getData() async {
    int userId =  await UsersData().userId();
    print('userid ${userId}');
    if (userId == 0) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      session = await SessionsData().currentSession();

      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'session': session
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 90.0,
        )
      ),
    );
  }
}
