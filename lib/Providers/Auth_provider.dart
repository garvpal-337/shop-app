import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/http_exceptions.dart';

class Auth with ChangeNotifier{
  String? _token;
  DateTime? _expiry;
  String? _userId;
  Timer? authTimer;


  bool get isAuth {
   return token != "null";
  }

  String get token{
    if( _token != null && _expiry!.isAfter(DateTime.now()) && _userId != null){
      return _token!;
    }
    return "null";
  }

  String get userId {
    return _userId ?? '';
  }

  Future<void> _authenticat(String Email, String Password,String urlPart) async{
    final url ="https://identitytoolkit.googleapis.com/v1/accounts:$urlPart?key=AIzaSyBNIybfxhBrYrPxTlpb8pmtcX_gpZJ5aJc";

   try {
     final response = await http.post(Uri.parse(url), body: jsonEncode({
       "email": Email,
       "password": Password,
       "returnSecureToken": true,
     }));
     print(jsonDecode(response.body));
     var responseData = jsonDecode(response.body);
     print("try");
     if(responseData["error"] != null){
       print("try");
       throw HttpException(responseData["error"]["message"]);
     };
     _token = responseData["idToken"];
     _userId = responseData["localId"];
     _expiry = DateTime.now().add(Duration(seconds: int.parse(responseData["expiresIn"])));
     print("LogIn == $_expiry,$_token,$_userId");
     autoLogoout();
     notifyListeners();
     final prefs = await SharedPreferences.getInstance();
     final userData = json.encode({
       "token" : _token,
       "expiryDate" : _expiry.toString(),
       "userId" : _userId,
     });
     prefs.setString('userData', userData);

   } catch (error){
     print(error);
     throw error;
   }

  }

  Future<void> signUp ( String Email, String Password) async{
  return _authenticat(Email, Password, "signUp");
  }

  Future<void> logIn( String Email, String Password) async{
  return _authenticat(Email, Password, "signInWithPassword");
  }

  Future <void> logOut () async{
    _userId = null;
    _token = null;
    _expiry = null;
    print("LogOut == $_expiry,$_token,$_userId,$isAuth");
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");

  }

  Future <bool> tryAutoLogin() async {
    print("trying auto login");
    final prefs = await SharedPreferences.getInstance();
    //print("data = ${json.decode(prefs.getString("userData")!) as Map<String, dynamic>}");

    if(!prefs.containsKey('userData')){
      print("false 1");
      return false;
    }

    final ExtractedData = json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(ExtractedData["expiryDate"]);
    if(expiryDate.isBefore(DateTime.now())){
      print("false 2");
      return false;
    } else {
      _token = ExtractedData["token"];
      _userId = ExtractedData["userId"];
      _expiry = expiryDate;
      notifyListeners();
      autoLogoout();
      return true;
    }
  }

  void autoLogoout(){
   if(authTimer != null){
     authTimer!.cancel();
   }
   var expiryTime = _expiry!.difference(DateTime.now()).inSeconds;
   print("endtime = $expiryTime");
   authTimer = Timer(Duration(seconds: expiryTime),logOut);
  }
}