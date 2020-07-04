import 'package:lifesweettreatsordernotes/models/order.dart';

class User {
  int id;
  String fname;
  String lname;
  String email;
  String photo;
  String type;
  List<Order> orders;

  User({this.id, this.fname, this.lname, this.email, this.photo, this.type, this.orders});

  double totalAmountToBePaid() {
    double total = 0;

    if (orders != null) {
      orders.forEach((order) {
        order.items.forEach((item) {
          if (order.status == 1) {
            total+= item.totalComuted();
          }
        });
      });
    }

    return total;
  }
}