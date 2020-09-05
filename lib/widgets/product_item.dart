import 'package:Ecomapp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

import '../providers/product.dart';


class ProductItem extends StatelessWidget {
//  final String imageUrl;
//  final String id;
//  final String title;

//   ProductItem(this.id,this.title,this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product= Provider.of<Product>(context,listen:false);
    final cart=Provider.of<Cart>(context);
    final scaffold=Scaffold.of(context);
    final authid=Provider.of<Auth>(context,listen:false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
          child: GridTile(
        child: GestureDetector(
          onTap: ()=>Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments:product.id,),
          child: Image.network(product.imageUrl,fit: BoxFit.cover,)),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading:
            Consumer<Product>(builder:(ctx,product,_) =>IconButton(
            icon:Icon(product.isFavourite ?Icons.favorite:Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: ()async{
              try{
                product.toggleFavourite(authid.token,authid.userId);
              }
              catch(_){
                scaffold.showSnackBar(SnackBar(content: Text('favourite Status could \'nt be updated')));
              }
            },)),
          title:Text(product.title,textAlign: TextAlign.center,),
          trailing: IconButton(
            icon:Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: (){
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added Item to the cart'),
                duration:Duration(seconds: 2),
                action: SnackBarAction(label: 'UNDO', onPressed: (){
                  cart.undoItem(product.id);
                }),)
              );
            },),
        ),
      ),
    );
  }
}