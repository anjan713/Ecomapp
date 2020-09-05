import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as ordy;

class OrderItem extends StatefulWidget {
  final ordy.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
    var _expanded=false;
      

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text('Rs ${widget.order.amount}'),
              subtitle: Text(DateFormat( 'dd MM yyyy hh:mm').format(widget.order.date),),
              trailing: IconButton(icon: Icon(_expanded ? Icons.expand_less :Icons.expand_more),
                onPressed: (){
                  setState(() {
                    _expanded=!_expanded;
                  });
                }),
          ),
          if(_expanded)  Container(
            margin:EdgeInsets.symmetric(horizontal:10,vertical:5),
            height: min(widget.order.products.length * 20.0 +10, 180),
            child:ListView(children:widget.order.products.map((e) => 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(e.title,style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
              Text(' ${e.quantity} X Rs${e.price}',style: TextStyle(color:Colors.grey,fontSize: 18),)
            ],)).toList(),
            )
          )
        ],
      ),
    );
  }
}