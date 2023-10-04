

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopapp/Providers/Cart_provider.dart';

class orderItems {
  final String id;
  final String orderId;
  final double amount;
  final List<CartItem> ItemsList;
  final DateTime datetime;
  orderItems({
     this.id = 'p1',
    required this.orderId,
    required this.amount,
    required this.ItemsList,
    required this.datetime,
});
}

class Orders with ChangeNotifier{
  List <orderItems> _Items =[];

  String authToken;
  String userId;
  Orders(this.authToken,this.userId,this._Items);

  List <orderItems> get items{
    return [..._Items];
   }

   Future<void> fetchDataAndPut() async {
     final url = "https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
   try {
     final response = await http.get(Uri.parse(url));
     final fetchData = jsonDecode(response.body) as Map<String, dynamic>;
     List<orderItems> fetchedOrder  = [];

     fetchData == null ? print('nothing') :fetchData.forEach((orderId, orderDetail) =>
     {
       fetchedOrder.insert(0, orderItems(
           orderId: orderId,
           amount: orderDetail["amount"],
           ItemsList: List<CartItem>.from(orderDetail["productdetails"].map((prod) => CartItem(
                 cartId: prod['cartId'],
                 id: prod['productId'],
                 title: prod['title'],
                 price: prod['price'],
                 Quantity: prod['quantity'],
                 ImageUrl: prod['imageUrl'])
           )).toList(),
           datetime: DateTime.parse(orderDetail['datetime']))),
     });
     _Items = fetchedOrder;
     notifyListeners();
   } catch (error){
    print(error);
     throw error;
   }
   }


  Future <void> addOrder(List<CartItem> cartProducts , double total) async {
   final url = "https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
   var datetime = DateTime.now();
  try {
    final respose = await http.post(Uri.parse(url), body: jsonEncode({
      'amount': total,
      'datetime': datetime.toIso8601String(),
      "productdetails": cartProducts.map((prod) =>
      {
        "cartId": prod.cartId,
        "productId": prod.id,
        "title": prod.title,
        "price": prod.price,
        "quantity": prod.Quantity,
        "imageUrl": prod.ImageUrl,

      }).toList(),
    }));
    print(jsonDecode(respose.body));
    _Items.insert(0, orderItems(
        orderId: jsonDecode(respose.body)['name'],
        amount: total,
        ItemsList: cartProducts,
        datetime: datetime));
    notifyListeners();
  } catch (error){
    print(error);
    throw error;
  }
  }

}