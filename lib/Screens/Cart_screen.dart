import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Tiles/Cart_tile.dart';
import '../Providers/Cart_provider.dart';
import '../Providers/orders_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartscreen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    //final String image = cart.Items[1]?.id ?? 'not';

    // final cartItem = cart.Items;
    // String not ='name';
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
        Expanded(
          flex: 1,
          child: Card(
            elevation: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor
                  ),),
                  Spacer(),

                  Chip(
                    label: Text('₹ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        // fontSize: 20,
                        // fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(10),

                    
                  ),
                  SizedBox(width: 10,),
                  Elevatedbutton(totalamount: cart.totalAmount,cartitems: cart.Items.values.toList(),clear: cart.clear,)

                ],
              ),
            ),
          ),
        ),

            Expanded(
            flex: 6,
            child: ListView.builder(itemBuilder: (ctx,index) {
               if(cart.itemCount > 0)
                 return CartTile(
                  Imageurl: cart.Items.values.toList()[index].ImageUrl ,
                  title: cart.Items.values.toList()[index].title ,
                  quantity: cart.Items.values.toList()[index].Quantity ,
                  price: cart.Items.values.toList()[index].price,
                  id : cart.Items.values.toList()[index].id ,
                 );
               else
                 return Container();
            },
            itemCount: cart.itemCount,),)
        ],
      ),
    );
  }
}

class Elevatedbutton extends StatefulWidget {
   Elevatedbutton({Key? key,
  required this.totalamount,
  required this.cartitems,
   required this.clear}) : super(key: key);

  final double totalamount;
  final List<CartItem> cartitems;
  final VoidCallback clear;

  @override
  State<Elevatedbutton> createState() => _ElevatedbuttonState();
}

class _ElevatedbuttonState extends State<Elevatedbutton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading?CircularProgressIndicator() :ElevatedButton(
        onPressed: widget.totalamount <=0 ? null : (){
      setState((){
        isLoading = true;
      });
      Provider.of<Orders>(context,listen: false).addOrder(
          widget.cartitems,
          widget.totalamount).then((_){
            return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Order placed successfully'),
                backgroundColor: Theme.of(context).primaryColor,
            ));
      }).then((_) => {
      setState((){
      isLoading = false;
      })
      });
      widget.clear();
    }, child: Text('Buy now'));
  }
}

