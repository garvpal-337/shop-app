import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/Editproduct_screen.dart';
import '../Providers/Product_provider.dart';
import '../Tiles/manage_products_tile.dart';
import '../Widgets/app_drawer.dart';

class manageProductScreen extends StatefulWidget {
  static const routeName = '/manageproductscreen';
  const manageProductScreen({Key? key}) : super(key: key);

  @override
  State<manageProductScreen> createState() => _manageProductScreenState();
}

Future<void> _fetchData (BuildContext context) async {
  await Provider.of<Products>(context,listen: false).fetchDataAndPut(true);
}

class _manageProductScreenState extends State<manageProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Manager'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(editProductScreen.routeName,arguments: {
              "ID" : "null",
              "TITLE" : "Add Product"
            });
          },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (ctx,snapShot) {
         return  snapShot.connectionState == ConnectionState.waiting ? Center(
            child: CircularProgressIndicator(),) : RefreshIndicator(
            onRefresh: () => _fetchData(context),
            child:Consumer<Products>(
              builder: (ctx,products,child) => Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: products.items.length,
                    itemBuilder: (_,i){
                      return manageProductTile(
                          Title: products.items[i].title,
                          imageUrl: products.items[i].imageUrl,
                          productId : products.items[i].id
                      );
                    }),
              ),
            ),),
          );
        }
      ),
      drawer: appDrawer(),
      drawerEdgeDragWidth: double.infinity,

    );
  }
}
