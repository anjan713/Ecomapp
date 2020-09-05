import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './providers/auth.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx)=>Auth()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth,Products>(
        update: (ctx,authen,previousState)=>Products(authen.token,authen.userId, previousState==null ? []: previousState.items)),
        ChangeNotifierProvider(
        create: (ctx)=>Cart()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth,Order>(
        update: (ctx,authen,previousState)=>Order(authen.token,previousState==null? []: previousState.orders)),
        
        ],
        child: Consumer<Auth>(builder: (ctx,authen,_)=>  MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: authen.auth ? ProductsOverviewScreen() : AuthScreen(),
    routes: {
          // '/':(ctx)=>  AuthScreen(),
          '/shop':(ctx)=> ProductsOverviewScreen(),
          ProductDetailScreen.routeName:(ctx)=> ProductDetailScreen(),
          CartScreen.routeName:(ctx)=> CartScreen(),
          OrderScreen.routeName:(ctx)=>OrderScreen(),
          UserProductScreen.routeName:(ctx)=>UserProductScreen(),
          EditProductScreen.routeName:(ctxx)=>EditProductScreen(),
    },
  )
        ,) 
      ) ;
  }
}

