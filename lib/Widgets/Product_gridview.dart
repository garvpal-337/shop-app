import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/splashScreen.dart';
import '../Providers/Product_provider.dart';
import 'package:shopapp/Tiles/product_tile.dart';

class ProductGridView extends StatelessWidget {

  bool showFavs;
  ProductGridView(this.showFavs);

  Future<void> _fetchData (BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchDataAndPut();
  }


  @override
  Widget build(BuildContext context) {

   // final productData = Provider.of<Products>(context);
    return FutureBuilder(
        future: _fetchData(context),
        builder: (ctx, snapShot) => snapShot.connectionState == ConnectionState.waiting
            ? Center(

          child: Container(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircularProgressIndicator(
                ),
                Text('Loading...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),)
              ],
            ),
          ),
        ) :RefreshIndicator(
      onRefresh: () => _fetchData(context),
      child: Consumer<Products>(
        builder: (ctx,productData,_){
          final productList = showFavs? productData.findFavs :  productData.items;
          return GridView.builder(
            padding: EdgeInsets.all(10),
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 320,

            ),

            itemBuilder: (context,index){
              return ChangeNotifierProvider.value(
                value: productList[index],
                child:  ProductTile(),
              );

            },
            itemCount: productList.length,
          );
        },
      )
    ));
  }
}
