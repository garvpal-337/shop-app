import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/Providers/Product_provider.dart';
import 'package:shopapp/Widgets/Cart_Badge.dart';
import 'package:shopapp/Providers/Cart_provider.dart';
import 'package:shopapp/Screens/Cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Widgets/Product_gridview.dart';
import 'package:shopapp/Widgets/app_drawer.dart';

enum popupOptions { All, WishList }

class productOverViewScreen extends StatefulWidget {
  static const routeName = '/productoverviewscreen';

  @override
  State<productOverViewScreen> createState() => _productOverViewScreenState();
}

class _productOverViewScreenState extends State<productOverViewScreen> {
  //const productOverViewScreen({Key? key}) : super(key: key);
  bool showWishlist = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false).fetchDataAndPut().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/png/campus_logo.webp',
            width: 150,
          ), //Image.network('https://res-2.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_256,w_256,f_auto,q_auto:eco/six0e2v2jerlgdhftd6p',height: 400,width: 150,),
          elevation: 10,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),

          actions: [
            Consumer<Cart>(builder: (ctx, Cart, _) {
              return //Badge(child:
                  IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.of(ctx).pushNamed(CartScreen.routeName);
                },
                padding: EdgeInsets.only(top: 7),
              );
              // value: Cart.itemCount.toString()
              //);
            }),
            PopupMenuButton(
              onSelected: (popupOptions selectedValue) {
                setState(() {
                  if (selectedValue == popupOptions.WishList) {
                    showWishlist = true;
                  } else {
                    showWishlist = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.black,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('All product'),
                  value: popupOptions.All,
                ),
                PopupMenuItem(
                    child: Text('Wishlist'), value: popupOptions.WishList)
              ],
            ),
          ],
          //backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7)
        ),
        drawer: appDrawer(),
        drawerEdgeDragWidth: double.infinity,
        drawerScrimColor: Colors.black54,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductGridView(showWishlist),
      ),
    );
  }
}
