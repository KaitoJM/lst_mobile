import 'package:lifesweettreatsordernotes/models/order.dart';

class Session {
  int id;
  String name;
  String startDate;
  String endDate;
  int status;
  List<Order> orders;

  Session({this.id, this.name, this.startDate, this.endDate, this.status, this.orders});


}