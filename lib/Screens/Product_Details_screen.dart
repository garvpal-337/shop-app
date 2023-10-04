import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/Product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName ='/productdetailspage';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final ProductId = ModalRoute.of(context)!.settings.arguments as String;
    final productList = Provider.of<Products>(context).findById(ProductId);

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Image.asset('assets/png/campus_logo.webp',width: 150,),
      //   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.4,
                  //color: Colors.red,
                  child: Image.asset('assets/png/campus_logo.webp',fit: BoxFit.fitWidth,)),
              centerTitle: true,
              expandedHeight: 500,
              pinned: true,
              toolbarHeight: 50,
              stretch: true,
              backgroundColor: Theme.of(context).primaryColor.withGreen(100),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                background: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      color: Colors.white,
                          border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.3)
                          ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).primaryColor.withOpacity(0.2)
                        ]
                    ),
                  ),
                  child:Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 50),
                    child: Hero(
                      tag: productList.id,
                      child: ClipRRect(
                          child: Image.network(productList.imageUrl,fit: BoxFit.fitHeight,)),
                    ),
                  ),
                ),
              ),
              elevation: 8,

            ),
            SliverList(delegate: SliverChildListDelegate([
              Padding(
                  padding: EdgeInsets.only(top: 30,bottom: 10,left: 20,right: 20),
                  child: Text(productList.title,
                      style:TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400
                      ))),
              Padding(
                  padding: EdgeInsets.only(top: 10,bottom: 30,left: 20,right: 20),
                  child: Text("Rs.${productList.price.toStringAsFixed(2)} /-",
                      style:TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ))),
              Divider(
                height: 10,
                thickness: 1,
                color: Theme.of(context).primaryColor,
                endIndent: 20,
                indent: 20,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                  child: Text(productList.description,
                      style:TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54
                      ))),
              SizedBox(height: 200,)

            ])),
          ],
        ),
      )

    );
  }
}
