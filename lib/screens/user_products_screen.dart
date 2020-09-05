import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static final routeName = '/user-product';
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .productsFromFirebase(true);
  }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _refreshProduct(context),
                      child: Consumer<Products>(
                        builder: (ctx, product, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                              itemCount: product.items.length,
                              itemBuilder: (_, i) {
                                return Column(
                                  children: <Widget>[
                                    UserProductItem(
                                      product.items[i].title,
                                      product.items[i].imageUrl,
                                      product.items[i].id,
                                    ),
                                    Divider()
                                  ],
                                );
                              }),
                        ),
                      ),
                    ),
        ));
  }
}
