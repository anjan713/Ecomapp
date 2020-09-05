
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

  class ProductDetailScreen extends StatelessWidget {
      static final routeName='/detail';
    
        @override
        Widget build(BuildContext context) {

      final id= ModalRoute.of(context).settings.arguments as String;

  final detailProduct=Provider.of<Products>(context,listen: false).detailProduct(id);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            detailProduct.title),
        ),
        body: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(detailProduct.imageUrl,fit: BoxFit.cover,),
              ),
              SizedBox(height: 10,),
              Text('Rs ${detailProduct.price}',style: TextStyle(color:Colors.grey,fontSize:20),),
              SizedBox(height: 10,),
              Text(detailProduct.description,textAlign: TextAlign.center,)
            ],
          )
        ),
      );
    }
  }