import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

  class CartItem extends StatelessWidget {
    final String productId;
    final String id;
    final String title;
    final double price;
    final int quantity;

    CartItem( this.productId,this.id, this.title, this.price, this.quantity);
    @override
    Widget build(BuildContext context) {
      return Dismissible(
              key: ValueKey(id),
              background: Container(
                color:Theme.of(context).errorColor,
                margin: EdgeInsets.symmetric(horizontal:15,vertical:4),    
                child: Icon(Icons.delete),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction){
                return showDialog(
                  context: context,
                  builder: (ctx)=>AlertDialog(title:Text('Are you Sure'),
                  content: Text('Do you Really wnat to remove item from cart'),
                  actions: <Widget>[
                    FlatButton(onPressed: (){
                      Navigator.of(context).pop(false);
                    }, child: Text('No')),
                    FlatButton(onPressed: (){
                      Navigator.of(context).pop(true);
                    }, child:Text('Yes'))
                  ],));
              },
              onDismissed:(direction){
              Provider.of<Cart>(context,listen:false).removeItem(productId); 
              },
              child: Card(
          margin: EdgeInsets.symmetric(horizontal:15,vertical:4),
          child: ListTile(
            leading:CircleAvatar(child:FittedBox(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('Rs$price')))),
            title: Text(title) ,
            subtitle: Text('Total ${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('quantity : $quantity'),
          ),
        ),
      );
    }
  }