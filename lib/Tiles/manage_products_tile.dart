import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Providers/Product_provider.dart';
import 'package:shopapp/Screens/Editproduct_screen.dart';


class manageProductTile extends StatelessWidget {
  const manageProductTile({Key? key,
  required this.Title,
  required this.imageUrl ,
  required this.productId
  }) : super(key: key);
  final String Title;
  final String imageUrl;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final Productprov = Provider.of<Products>(context,listen: false);
    return Card(
      elevation: 6,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        child: ListTile(
          dense: true,
          title: Text(Title,maxLines: 2,overflow: TextOverflow.ellipsis,),
          leading: ClipRRect(
            child: Image.network(imageUrl,fit: BoxFit.cover,),
          ),
          trailing: Container(
            width: 100,
           child: Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pushNamed(editProductScreen.routeName,arguments: {
                    "ID" : productId,
                    "TITLE" : "Edit Product"
                  });
                },
                    icon: Icon(Icons.edit_note,color: Theme.of(context).primaryColor,))

               , IconButton(onPressed: (){

                  showDialog(
                     context: context,
                     builder: (BuildContext ctx){
                       return AlertDialog(
                         alignment: Alignment.center,
                         actionsPadding: EdgeInsets.all(10),
                         actionsAlignment: MainAxisAlignment.spaceEvenly,
                         content: Text('You want to delete this product?'),
                         actions: [
                           TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('NO')),

                           TextButton(onPressed: (){
                             Productprov.removeProduct(productId);
                             Navigator.of(context).pop();
                           }, child: Text('YES'))
                         ],
                       );
                     });


                },
                    icon: Icon(Icons.delete_forever_sharp,color: Colors.red.withOpacity(0.7),))
              ],
            )
          ),
        ),
      ),
    );
  }
}
