import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/components/session_row.dart';

class SessionList extends StatefulWidget {
  @override
  _SessionListState createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  List<Session> sessions = [];

  void getData() async {
    Response response = await get('http://172.18.5.209:8080/api/get-sessions');

    List<dynamic> sessionLists = json.decode(response.body);
    sessionLists.forEach((element) {
      sessions.add(
        Session(
          id: element['id'],
          name: element['name'],
          startDate: element['start_date'],
          endDate: element['end_date'],
          status: element['status']
        )
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/sessions');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent[100],
      ),
      appBar: AppBar(
        title: Text('Sessions'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: Container(
          height: 100,
          child: ListView(
            children: sessions.map((session) {
              return SessionRow(session: session);
            }).toList(),
          ),
        )
      )
    );
  }
}
