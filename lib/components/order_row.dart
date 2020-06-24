import 'package:flutter/material.dart';
import '../models/order.dart';

enum rowOption { showItems, edit, remove }

class OrderRow extends StatelessWidget {
  final Order order;
  final Function edit;
  final Function delete;
  final Function openDetails;

  OrderRow({this.order, this.edit, this.delete, this.openDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
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
            Text(order.total.toString()),
            SizedBox(
              width: 30,
              height: 30,
              child: PopupMenuButton<rowOption>(
                onSelected: (rowOption result) {
                  if (result == rowOption.showItems) {
                    openDetails();
                  }
                  if (result == rowOption.edit) {
                    edit();
                  }
                  if (result == rowOption.remove) {
                    delete();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<rowOption>>[
                  const PopupMenuItem<rowOption>(
                    value: rowOption.showItems,
                    child: Text('Show order items'),
                  ),
                  const PopupMenuItem<rowOption>(
                    value: rowOption.edit,
                    child: Text('Edit order'),
                  ),
                  const PopupMenuItem<rowOption>(
                    value: rowOption.remove,
                    child: Text('Cancel order'),
                  ),
                ],
              )
            ),
          ],
        ),
        Text(
          '- ${order.authorFName} ${order.authorLName}',
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold
          ),
        ),
        Divider(
          height: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}