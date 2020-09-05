import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Order;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
class OrderScreen extends StatelessWidget {
  static final routeName='/orderlist'; 
  
  @override
  Widget build(BuildContext context) {
    // final order=Provider.of<Order>(context);
    return Scaffold(
          appBar: AppBar(title:Text('Your Orders')),
          drawer: AppDrawer(),
          body: FutureBuilder(
            future:Provider.of<Order>(context,listen:false).retriveOrderData(),
            builder: (ctx,snapshotData){
              if (snapshotData.connectionState==ConnectionState.waiting) 
              {
              return  Center(child:CircularProgressIndicator());
              }
              if (snapshotData.error != null) {
              return  Center(child:Text('error while connecting to server'));
              }
              else {
              return Consumer<Order>(builder: (ctx,order,child)=>  ListView.builder(
                itemCount: order.orders.length,
                itemBuilder: 
                (ctx,i)=>(OrderItem(order.orders[i])
            )
            )
              );  
              }
            },
          )
    ); 
  }
}