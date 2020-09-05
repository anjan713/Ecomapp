import 'package:flutter/foundation.dart';

class CartItem{
final String id;
final String title;
final double price;
final int quantity;

CartItem({
  @required this.id,
  @required this.title,
  @required this.price,
  @required this.quantity
  });

}

    class Cart extends ChangeNotifier{
      Map <String,CartItem> _items={};

      Map <String,CartItem> get items{
      return {..._items};
      }
    int get itemCount{
      return   _items.length;
    }

    double get totalAmount{
      var total=0.0;

    _items.forEach((key, cartItem) {
      total +=   (cartItem.price * cartItem.quantity);
      });
      return double.parse((total).toStringAsFixed(2)); 
    }

      addItem(String productId,String title,double price){


      if(_items.containsKey(productId)){
      _items.update(productId, (existingItem) => CartItem(id:existingItem.id,title:existingItem.title,price: existingItem.price,quantity: existingItem.quantity+1,));
            }else{
        _items.putIfAbsent(productId, () => CartItem(id: DateTime.now().toString(),title: title,price: price,quantity: 1));     
      
    }
        notifyListeners();

      }
        removeItem(String productId){
          _items.remove(productId); 
          notifyListeners();  
        } 
        void clearItems(){
          _items.clear();
          notifyListeners();  
        } 
          void undoItem(String productId){
            if(!_items.containsKey(productId)){
              return;
            }
            if (_items[productId].quantity>1) {
                _items.update(productId, (existingValue) => CartItem(id: existingValue.id, title: existingValue.title, price:existingValue.price, quantity: existingValue.quantity - 1));
            }
            else {
                _items.remove(productId);
            }
            notifyListeners();
          } 

    }