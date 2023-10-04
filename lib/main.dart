

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/splashScreen.dart';

import './Providers/Auth_provider.dart';
import './Screens/Auth_screen.dart';
import './Screens/product_overView_screen.dart';
import './Providers/orders_provider.dart';
import './Screens/Cart_screen.dart';
import './Screens/Product_Details_screen.dart';
import './Providers/Cart_provider.dart';
import './Screens/order_screen.dart';
import './Providers/Product_provider.dart';
import './Screens/Manage_product_screen.dart';
import './Screens/Editproduct_screen.dart';




void main() => runApp(MyShopApp());

class MyShopApp extends StatelessWidget {

  bool showWishlist = false;
  @override
  Widget build(BuildContext context) {
    return   MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth()),
      ChangeNotifierProxyProvider<Auth , Products>(
            create: (ctx) => Products("","", []),
            update: (ctx, auth, previousProducts) => Products(auth.token,
                auth.userId,
                previousProducts == null? [] :  previousProducts.items),
      ),
        ChangeNotifierProvider(
        create: (ctx) => Cart()),
      ChangeNotifierProxyProvider<Auth , Orders>(
        create: (ctx) => Orders("","",[]),
        update: (ctx, auth, previousProducts) => Orders(auth.token,
            auth.userId,
            previousProducts == null? [] :  previousProducts.items),
      ),
    ],
      child: Consumer<Auth>(builder: (ctx,auth,_) =>MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            ProductDetailScreen.routeName : (ctx) => ProductDetailScreen(),
            CartScreen.routeName : (ctx) => CartScreen(),
            orderScreen.routeName : (ctx) => orderScreen(),
            productOverViewScreen.routeName : (ctx) => productOverViewScreen(),
            manageProductScreen.routeName : (ctx) => manageProductScreen(),
            editProductScreen.routeName : (ctx) => editProductScreen(),
            userAuthScreen.routName : (ctx) => userAuthScreen(),
          },
          home: auth.isAuth ?  productOverViewScreen() :FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting? splashScreen(): userAuthScreen()), //productOverViewScreen(),
      ),),

    );
  }
}
