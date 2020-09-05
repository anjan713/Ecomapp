import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './product_item.dart';
class ProductGrid extends StatelessWidget {

  final bool showFav;
  ProductGrid(this.showFav);
  
  @override
  Widget build(BuildContext context) {
final productData=  Provider.of<Products>(context);
  final loadedProducts=showFav ? productData.favouriteList: productData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10
      ),
        itemBuilder: (ctx,i){
      return  ChangeNotifierProvider.value(
            value:loadedProducts[i],
            child: ProductItem(
          //  loadedProducts[i].id,
          //  loadedProducts[i].title,
          //  loadedProducts[i].imageUrl
              ),
      );
        },
        itemCount: loadedProducts.length,
        );
  }
}
