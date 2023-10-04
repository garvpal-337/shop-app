import 'dart:math';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import '../../Providers/Cart_provider.dart';
import '../../Screens/Product_Details_screen.dart';

class ordersTile extends StatefulWidget {
  const ordersTile({Key? key,
  required this.total,
  required this.Datetime,
    required this.Cartitems,
  }) : super(key: key);
  final double total;
  final DateTime Datetime;
  final List<CartItem> Cartitems;

  @override
  State<ordersTile> createState() => _ordersTileState();
}

class _ordersTileState extends State<ordersTile> {
   bool expanded = false;

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
      height: expanded? min(widget.Cartitems.length * 50.0 +100,350.0) : 90,
      child: Card(
        elevation: 6,
          child : Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            ListTile(
            title: Text('₹ ${widget.total.toStringAsFixed(2)}',
            style:TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600
            )),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range,size: 18,),
                    Text(formatDate(widget.Datetime, [dd,'/',mm,'/',yyyy])),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time,size: 18,),
                    Text(formatDate(widget.Datetime, [hh,':',nn,])),
                  ],
                )
              ],
            ),
            leading: Icon(Icons.shopify,color: Theme.of(context).primaryColor,size: 40,),
            trailing: IconButton(
                onPressed: (){
                  setState((){
                    expanded = !expanded;
                  });
                },
                icon: !expanded ? Icon(Icons.expand_more) : Icon(Icons.expand_less)),

          ),
           AnimatedContainer(
             duration: Duration(milliseconds: 300),
             curve: Curves.linear,
             height: expanded? min(widget.Cartitems.length * 50.0 +10,250.0) : 0,

            // height: min(widget.Cartitems.length * 50.0 +10,250.0),
             child: ListView.builder(itemBuilder:(context,i){
               return GestureDetector(
                 onTap: (){
                   Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                   arguments: widget.Cartitems[i].id
                   );
                 },
                 child: Container(
                   alignment: Alignment.center,
                   height: 50,
                   padding: EdgeInsets.all(1),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Expanded(
                       flex: 1,
                       child: Container(
                           decoration: BoxDecoration(
                             border: Border.all(color: Theme.of(context).primaryColor)
                           ),
                           child: Image.network(widget.Cartitems[i].ImageUrl,fit: BoxFit.fitHeight,)),
                     ),
                     SizedBox(width: 5,),
                     Expanded(
                         flex: 4,
                         child: Text(widget.Cartitems[i].title,overflow: TextOverflow.ellipsis,maxLines: 1,softWrap: true)),
                     Spacer(),
                     Expanded(
                         flex: 2,
                         child: Text("${widget.Cartitems[i].Quantity} x ${widget.Cartitems[i].price.toStringAsFixed(2)}"))
                   ],
                 ),
                 ),
               );
              },
               itemCount: widget.Cartitems.length,
              ),
      ),
      ],
      ),
      )),
    );


  }
}
