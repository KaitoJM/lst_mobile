import 'package:lifesweettreatsordernotes/models/order.dart';
import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';

class Session {
  int id;
  String name;
  String startDate;
  String endDate;
  int status;
  double expense = 0;
  List<Order> orders;
  List<SessionProduct> products;


  String assigneeName;

  Session({this.id, this.name, this.startDate, this.endDate, this.status, this.orders, this.products, this.assigneeName, this.expense});

  double total_paid() {
    double total = 0;

    if (orders != null) {
      orders.forEach((order) {
        if (order.status == 1) {
          total += order.total;
        }
      });
    } else {
      if (products != null) {
        products.forEach((product) {
          total += product.totalPaid();
        });
      }
    }

    return total;
  }

  double total() {
    double total = 0;
    if (orders != null) {
      orders.forEach((order) {
        total += order.total;
      });
    } else {
      if (products != null) {
        products.forEach((product) {
          total += product.total();
        });
      }
    }

    return total;
  }

}