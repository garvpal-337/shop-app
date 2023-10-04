import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  int Quantity;
  double price;
  String ImageUrl;
  String cartId;
  CartItem({
    required this.cartId,
    required this.id,
    required this.title,
    required this.price,
    required this.Quantity,
    required this.ImageUrl,
  });
}

class Cart with ChangeNotifier{
  Map<String,CartItem>  _Items ={};
  Map<String,CartItem> get Items{
    return {..._Items};

  }

  void addItem({required String id,required String title , required double price,required String imageUrl}){
    if(_Items.containsKey(id)){
        _Items.update(id, (existingValue) => CartItem(
            cartId: existingValue.cartId,
            id: existingValue.id,
            title: existingValue.title,
            price: existingValue.price,
            ImageUrl: existingValue.ImageUrl,
            Quantity: existingValue.Quantity + 1));
        notifyListeners();
    }else {
        _Items.putIfAbsent(id, () => CartItem(
            cartId: DateTime.now().toString(),
            id: id,
            title: title,
            price: price,
            Quantity: 1,
             ImageUrl: imageUrl ));
        notifyListeners();
    }

  }

  double get totalAmount {
    double total = 0.0;
    _Items.forEach((key, Item) {
      total +=  Item.price * Item.Quantity;
    });
    return total;
  }

  bool isCartItem (String id){
    return _Items.containsKey(id);
  }

  int get itemCount{
    return _Items.length;
  }

  void removeItem(String id){
    _Items.remove(id);
    notifyListeners();
  }
   void clear(){
    _Items = {};
    notifyListeners();
   }
   void increaseQuantity(String id){
     _Items.update(id, (existingValue) => CartItem(
         cartId: existingValue.cartId,
         id: existingValue.id,
         title: existingValue.title,
         price: existingValue.price,
         ImageUrl: existingValue.ImageUrl,
         Quantity: existingValue.Quantity + 1));
     notifyListeners();
   }

   void decreaseQuatity(id){
     _Items.update(id, (existingValue) => CartItem(
         cartId: existingValue.cartId,
         id: existingValue.id,
         title: existingValue.title,
         price: existingValue.price,
         ImageUrl: existingValue.ImageUrl,
         Quantity: existingValue.Quantity > 1? existingValue.Quantity - 1 : 1));
     notifyListeners();
   }

   void undoAddItem(String productId){
    if(!_Items.containsKey(productId)){
      return;
    }
    if(_Items[productId]!.Quantity > 1){
      decreaseQuatity(productId);
    }else{
      removeItem(productId);
    }
   }
}