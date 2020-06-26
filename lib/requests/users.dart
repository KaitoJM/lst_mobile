import 'package:http/http.dart';
import 'dart:convert';

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
}