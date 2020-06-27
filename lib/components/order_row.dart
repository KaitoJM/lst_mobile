import 'package:flutter/material.dart';
import '../models/order.dart';

enum rowOption { showItems, edit, remove }

class OrderRow extends StatelessWidget {
  final Order order;

  OrderRow({this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                child: Icon(
                  (order.status == 1) ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Colors.green[200],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text(
                  order.productCount.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Expanded(
                child: Text('${order.customerFName} ${order.customerLName}'),
              ),
              Text('₱${order.total.toString()}'),
            ],
          ),
          Text(
            '- ${order.authorFName} ${order.authorLName}',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}