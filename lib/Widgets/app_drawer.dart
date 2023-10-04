import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/Auth_provider.dart';
import 'package:shopapp/Screens/Auth_screen.dart';
import 'package:shopapp/Screens/Manage_product_screen.dart';
import 'package:shopapp/Screens/order_screen.dart';
import 'package:shopapp/Screens/product_overView_screen.dart';

class appDrawer extends StatelessWidget {
  const appDrawer({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
   final logout = Provider.of<Auth>(context);
    return Drawer(

     child: ListView(

       children: [
         AppBar(
           title: Image.asset('assets/png/campus_logo.webp',width: 150,),
           backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
         ),
         SizedBox(height: 10,),
         ListTile(
           title: Text('Shop'),
           leading: Icon(Icons.shopping_bag_outlined,color:Theme.of(context).primaryColor),
           onTap:() {
             Navigator.of(context).pushReplacementNamed(productOverViewScreen.routeName);
           },
         ),
         Divider(thickness: 1,
           color:  Theme.of(context).primaryColor.withOpacity(0.7),
           indent: 20,
           endIndent: 20,),
         ListTile(
           title: Text('Orders'),
           leading: Icon(Icons.shopify_outlined,color:Theme.of(context).primaryColor),
           onTap:() {
             Navigator.of(context).pushReplacementNamed(orderScreen.routeName);
           },
         ),
         Divider(thickness: 1,
           color:  Theme.of(context).primaryColor.withOpacity(0.7),
         indent: 20,
         endIndent: 20,),
         ListTile(
           title: Text('Manage products'),
           leading: Icon(Icons.edit_note,color:Theme.of(context).primaryColor),
           onTap:() {
             Navigator.of(context).pushReplacementNamed(manageProductScreen.routeName);

           },
         ),
         Divider(thickness: 1,
           color:  Theme.of(context).primaryColor.withOpacity(0.7),
           indent: 20,
           endIndent: 20,),
         ListTile(
           title: Text('Log out'),
           leading: Icon(Icons.logout_sharp,color:Theme.of(context).primaryColor),
           onTap:() {
            // Navigator.of(context).pushReplacementNamed(productOverViewScreen.routeName);

             // Provider.of<Auth>(context,listen: false).logOut();
             // Navigator.of(context).pop();
             // //Navigator.of(insideContext).pop();
             // logout.logOut();
             // Navigator.of(context).pushReplacementNamed("/");

             showDialog(context: context,
                 builder: (BuildContext insideContext){
                  return AlertDialog(
                    title: Text("Are you sure?"),
                    content: Text("You want to log out?"),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.of(insideContext).pop();
                      },
                          child: Text("NO")),
                      TextButton(
                        child: Text("YES"),
                        onPressed: () {
                          Navigator.of(insideContext).pop();
                          logout.logOut();
                          Navigator.of(insideContext).pushReplacementNamed("/");
                          } ,
                      )
                    ],
                  );
                 });
           },
         ),
       ],
     ),
    );
  }
}
