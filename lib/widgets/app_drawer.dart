import 'package:flutter/material.dart';

import '../screens/order_screen.dart';
import '../screens/user_products_screen.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:ListView(
          padding:EdgeInsets.all(0),
          children: <Widget>[
            AppBar(title:Text('FastCart'),
            automaticallyImplyLeading: false,),
              Divider(),
              ListTile(
                  onTap: (){
                Navigator.of(context).pushNamed(OrderScreen.routeName);
                  },
                title:Text('Your Orders'),
                leading: Icon(Icons.payment),
              ),
              Divider(),
              ListTile(
                  onTap: (){
                Navigator.of(context).pushNamed('/');
                  },
                title:Text('Shop'),
                leading: Icon(Icons.shop),
              ),
              Divider(),
              ListTile(
                  onTap: (){
                Navigator.of(context).pushNamed(UserProductScreen.routeName);
                  },
                title:Text('Manage Products'),
                leading: Icon(Icons.edit),
              ),
          ],)
      );
  }
}