import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Product extends ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite=false,
  });
void fav(save){
        isFavourite=save;
      notifyListeners();
}
    
  Future<void> toggleFavourite(String authtoken,String userId)async{
    // final url='https://flutter-backendserver.firebaseio.com/Products/$id.json?auth=$authtoken';
    final url='https://flutter-backendserver.firebaseio.com/userFavourite/$userId/$id.json?auth=$authtoken';
    
    var saveFavourite=isFavourite;
    isFavourite=!isFavourite;
    notifyListeners();
    try{
      final response=await http.put(url,body:json.encode(
        isFavourite
      ));
      if (response.statusCode>=400) {
        fav(saveFavourite);
        throw HttpException('unable to send the data');
      }
    }catch(_){
        fav(saveFavourite);
        throw HttpException('Network error 400');
    }
  }
}