import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/Auth_provider.dart';
import 'package:shopapp/Screens/Product_Details_screen.dart';
import 'package:shopapp/Providers/product_class_provider.dart';
import '../Providers/Cart_provider.dart';



class ProductTile extends StatefulWidget {

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {


  void showToast(String Ttitle){

       final scaffold = ScaffoldMessenger.of(context);
       scaffold.hideCurrentSnackBar();
       scaffold.showSnackBar(
         SnackBar(
             content: Text(Ttitle,
             style: TextStyle(
               fontSize: 17,
             ),),
             backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
           elevation: 6,)
        );
       }


       @override
  Widget build(BuildContext context) {
    final Product = Provider.of<product>(context,listen: false);
    final authData = Provider.of<Auth>(context,listen: false);
    void FavFunction(){
      Product.toggleFavorite(authData.token,authData.userId);
      Product.isFavorite? showToast('Added to Wishlist'):showToast('Removed from Wishlist');
    }
    print('Product Tile build');
    return Consumer<product>(
      builder: (ctx,Product,_) => GestureDetector(
        onDoubleTap: FavFunction,
        dragStartBehavior: DragStartBehavior.start,
        onTap:() {
          Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
              arguments: Product.id );
        },
        child: Card(
          elevation: Product.isFavorite? 30 : 6 ,
          shadowColor: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      child: Hero(
                        tag: Product.id,
                        child: FadeInImage(
                          placeholder: AssetImage("assets/png/campus_logo.webp"),
                          image: NetworkImage(Product.imageUrl),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ) ,
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                            onPressed: FavFunction,
                            icon: Product.isFavorite? Icon(Icons.favorite): Icon(Icons.favorite_border,),
                          ),
                        ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Consumer<Cart>(
                        builder: (ctx,Cart,_) =>IconButton(
                          onPressed: (){
                              Cart.addItem(
                                  id: Product.id,
                                  title: Product.title,
                                  price: Product.price,
                                  imageUrl: Product.imageUrl);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Added to Cart',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),),
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
                                elevation: 6,
                                //padding: EdgeInsets.only(left: 50,top: 20,bottom: 20),

                                action: SnackBarAction(
                                  label: 'UNDO',
                                  textColor: Colors.white,
                                  onPressed: (){
                                   Cart.undoAddItem(Product.id);
                                  },
                                ),

                              ));
                          },
                          icon: Cart.isCartItem(Product.id)? Icon(Icons.add_shopping_cart_sharp):Icon(Icons.shopping_cart_outlined),
                        ),
                      )
                    ),

                  ],
                    ),
                   ),

              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rs. ${Product.price.toStringAsFixed(2)} ",textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 5,),
                    Text(Product.title,style: TextStyle(
                        //fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),overflow: TextOverflow.ellipsis,maxLines: 2,softWrap: true,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
