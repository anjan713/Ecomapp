import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, items);

  List<Product> get favouriteList {
    return items.where((meals) => meals.isFavourite == true).toList();
  }

// Future<void> toggleFavourite(String idr)async{
//         final url='https://flutter-backendserver.firebaseio.com/Products/$idr.json';
//       await http.patch(url,body:json.encode({

//       }));
// }

// void showFavouriteItems(){
//  _showOnlyFavourite=true;
//   notifyListeners();
// }
// void showAllItems(){
//  _showOnlyFavourite=false;
//   notifyListeners();

// }
  List<Product> get items {
    return [..._items];
  }

  detailProduct(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> productsFromFirebase([bool filterByUser = false]) async {
    final String filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-backendserver.firebaseio.com/Products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://flutter-backendserver.firebaseio.com/userFavourite/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[productId] ?? false,
            imageUrl: productData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final url =
        'https://flutter-backendserver.firebaseio.com/Products.json?auth=$authToken';
    try {
      final value = await http.post(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavourite': newProduct.isFavourite,
          'creatorId': userId,
        }),
      );
      final product = Product(
          id: json.decode(value.body)['name'],
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl);
      _items.add(product);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String idPd, Product editProduct) async {
    final _indexnp = _items.indexWhere((element) => element.id == idPd);
    if (_indexnp >= 0) {
      final url =
          'https://flutter-backendserver.firebaseio.com/Products/$idPd.json?auth=$authToken';
      try {
        final response = await http.patch(url,
            body: json.encode({
              'title': editProduct.title,
              'description': editProduct.description,
              'price': editProduct.price,
              'imageUrl': editProduct.imageUrl,
              'isFavourite': editProduct.isFavourite,
            }));
        _items[_indexnp] = editProduct;
        notifyListeners();
        print(json.decode(response.statusCode.toString()));
      } catch (_) {
        print('well we got an error');
      }
    }
  }

  Future<void> deleteProduct(String idr) async {
    final _indexdelete = _items.indexWhere((item) => item.id == idr);
    if (_indexdelete >= 0) {
      var _deleteProduct = _items[_indexdelete];
      _items.removeAt(_indexdelete);
      notifyListeners();
      final url =
          'https://flutter-backendserver.firebaseio.com/Products/$idr.json?auth=$authToken';
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(_indexdelete, _deleteProduct);
        notifyListeners();
        throw HttpException('Product could\'nt be deleted');
      }
      _deleteProduct = null;
    }
  }
}
