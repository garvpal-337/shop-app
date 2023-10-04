import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Screens/Product_Details_screen.dart';
import 'package:shopapp/Providers/Cart_provider.dart';

class CartTile extends StatelessWidget {
  const CartTile({
    Key? key,
    required this.Imageurl,
    required this.title,
    required this.quantity,
    required this.price,
    required this.id
  }) : super(key: key);
   final String Imageurl;
   final String title;
   final int quantity;
   final double price;
   final String id;
  @override
  Widget build(BuildContext context) {
    // final Cartprov = Provider.of<Cart>(context,listen: false);
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
            arguments: id);
      },
      child: Dismissible(
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction){
          return showDialog(context: context,
              builder: (ctx){
              return AlertDialog(
                title: Text('Are you sure?',textAlign: TextAlign.left),
                content: Text('You want to remove it from Cart?',textAlign: TextAlign.center,),
                alignment: Alignment.center,
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                      TextButton(onPressed: (){
                        Navigator.of(ctx).pop(false);
                      },
                          child: Text('NO'),),
                      TextButton(onPressed: (){
                        Navigator.of(ctx).pop(true);
                      },
                          child: Text('Yes'),)

                ],
              );
              });
        },
        onDismissed: (direction){
          Provider.of<Cart>(context,listen: false).removeItem(id);
        },
        key: ValueKey(id),
        background: Container(
          padding: EdgeInsets.only(right: 20),
          color: Colors.red,
          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Remove', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),),
              SizedBox(width: 10,),
              Icon(Icons.delete_forever_sharp,color: Colors.white,size: 30,)
            ],
          ),
        ),
        child: Card(
          elevation: 6,
          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
          child: Container(
            height: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: 50,
                    height: 110,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor,width: 1),
                    ),
                    child: ClipRRect(

                        child: Image.network(Imageurl,width: 100,height: 100,fit: BoxFit.fitHeight,)),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,


                        children: [
                          Text(title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),maxLines: 2,overflow: TextOverflow.ellipsis,),

                          Text('Price : ${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              //fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<Cart>(
                            builder:(ctx,Cart,_) => Row(
                              children: [
                                IconButton(onPressed: quantity == 1? null : () {
                                  Cart.decreaseQuatity(id);
                                },
                                    icon: Icon(Icons.remove)),
                                Text('qty : $quantity',
                                  style: TextStyle(
                                      //fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),),
                                IconButton(onPressed: (){
                                  Cart.increaseQuantity(id);
                                },
                                    icon: Icon(Icons.add)),

                              ],
                            ),
                          ),


                          Chip(
                              label: Text('₹${(price*quantity).toStringAsFixed(2)}',style:
                                TextStyle(
                                  color: Colors.white
                                ),),
                          elevation: 1,
                          backgroundColor: Theme.of(context).primaryColor,)
                        ],
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
