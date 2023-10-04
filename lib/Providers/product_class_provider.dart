import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class product with ChangeNotifier{
  String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;
  product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  void _iferror(newvalue){
    isFavorite = newvalue;
    notifyListeners();
  }

  void toggleFavorite( String authToken,String userId) async{
    final url = 'https://flutter-app-1-cf1e6-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$authToken';

    final oldValue = isFavorite;
     isFavorite = !isFavorite;
     notifyListeners();
   try {
     final response = await http.put(Uri.parse(url), body: json.encode(isFavorite));
     if(response.statusCode >= 400){
       _iferror(oldValue);
     }
     print(response.body);
   } catch (error){
     print(error);
     _iferror(oldValue);
   }
  }
}
