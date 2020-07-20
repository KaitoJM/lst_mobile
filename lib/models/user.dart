import 'package:lifesweettreatsordernotes/models/Transaction.dart';
import 'package:lifesweettreatsordernotes/models/order.dart';

class User {
  int id;
  String fname;
  String lname;
  String email;
  String photo;
  String type;
  List<Order> orders;
  List<TransactionModel> transactions;

  double cashRecieveAmount; //for payment
  bool pay_bank = false;
  bool loadingAddingCash = false;

  User({this.id, this.fname, this.lname, this.email, this.photo, this.type, this.orders, this.transactions});

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

  double totalAmount() {
    double total = 0;

    if (orders != null) {
      orders.forEach((order) {
        order.items.forEach((item) {
          total+= item.totalComuted();
        });
      });
    }

    return total;
  }

  double totalCashReceived() {
    double total = 0;

    if (transactions.length != null) {
      transactions.forEach((transaction) {
        total += transaction.amount;
      });
    }

    return total;
  }

}