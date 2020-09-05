import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.date});
}

class Order with ChangeNotifier{
  List<OrderItem> _orders=[];
  List<OrderItem> get orders{
    return [..._orders];
  }

  final String authToken;
  Order(this.authToken,orders);
  Future<void> addOrder(List<CartItem> cartProduct,double total)async{
    final url='https://flutter-backendserver.firebaseio.com/Orders.json?auth=$authToken';
    final timeStamp=DateTime.now();
      final response = await  http.post(url,body:json.encode({
        'price':total,
        'date':timeStamp.toIso8601String(),
        'products':cartProduct.map((ce) => {
          'id':ce.id,
          'title':ce.title,
          'price':ce.price,
          'quantity':ce.quantity,
        }).toList(),
      }));

    _orders.insert(0,OrderItem(
      id: json.decode(response.body)['name'],
      amount: total, 
      products: cartProduct, 
      date: timeStamp)  );
    notifyListeners();
  }
  Future<void> retriveOrderData()async{
    final url='https://flutter-backendserver.firebaseio.com/Orders.json?auth=$authToken';
    List<OrderItem> loadOrders=[];
    final orderData=await http.get(url);
    if(orderData==null){
      return ;
    }
    final intermediateData=json.decode(orderData.body) as Map<String,dynamic>;
    intermediateData.forEach((productId, productData) { 
      loadOrders.add(OrderItem(
        id: productId,
        amount: productData['price'], 
        date:DateTime.parse(productData['date']) ,
        products: (productData['products'] as List<dynamic>).map((etr)=>  CartItem(
            id: etr['id'],
            title: etr['title'], 
            price: etr['price'],
            quantity: etr['quantity'],
            )
        ).toList(), 
        ));
    });
    _orders=loadOrders.reversed.toList();
    notifyListeners();
  }

}