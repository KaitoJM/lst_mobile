import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lifesweettreatsordernotes/models/user.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class UsersData {
  Future<List<User>> getUsers() async {
    print('Loading Users...');
    Response responseUser = await get('${global.api_url}get-users');
    print('Loaded Users');
    List<dynamic> userArray = json.decode(responseUser.body);
    List<User> user_temp = List<User>();

    userArray.forEach((user) {
      user_temp.add(new User(
          id: user['id'],
          fname: user['fname'],
          lname: user['lname'],
          email: user['email'],
          photo: user['photo']
      ));
    });

    return user_temp;
  }

  Future<Map> login(String email, String password) async {
    print('Loggin in...');
    Response response = await post('${global.api_url}login',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': email,
          'password': password
        })
    );
    var data = json.decode(response.body);
    if(response.statusCode == 200)
      {
        final prefs = await SharedPreferences.getInstance();
//        prefs.setInt('user_id', data['user_id']);
//        prefs.setString('key', email);
//        prefs.setString('key', password);
        return data;
      }
//    return null;

//    print('Login request done.');

    return json.decode(response.body);
  }

  Future<int> userId() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  Future logOut() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('user_id', 0);
  }
}