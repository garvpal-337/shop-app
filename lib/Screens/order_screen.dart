import'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/orders_provider.dart';
import 'package:shopapp/Widgets/app_drawer.dart';
import 'package:shopapp/Tiles/order_tile.dart';

class orderScreen extends StatefulWidget {
  static const routeName = "/orderscreen";
  const orderScreen({Key? key}) : super(key: key);

  @override
  State<orderScreen> createState() => _orderScreenState();
}

class _orderScreenState extends State<orderScreen> {

  Future? _obtained;

  Future <void> _obtainedData ()async{
    await Provider.of<Orders>(context,listen: false).fetchDataAndPut();
  }

  Future <void> _refresh() async{
    await Provider.of<Orders>(context,listen: false).fetchDataAndPut();
  }

  // var isLoading = false;
  @override
  void initState(){
    _obtained = _obtainedData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body:FutureBuilder(
        future: _obtained,
        builder: (ctx,snapShot) {
          if(snapShot.connectionState == ConnectionState.waiting){
           return Center(
              child: CircularProgressIndicator(),
            );
          } if(snapShot.error != null){
            return Center(
              child: Container(
                child: Text('An error occured\nor\nno order placed yet!',textAlign: TextAlign.center,),
            ));
          } if(snapShot.connectionState ==ConnectionState.done){
            return Consumer<Orders>(builder: (context, orderitems,child) =>Container(
                child: RefreshIndicator(
                  onRefresh: () => _refresh(),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: orderitems.items.length,
                    itemBuilder: (ctx,i){
                      return ordersTile(
                        total: orderitems.items[i].amount,
                        Datetime : orderitems.items[i].datetime ,
                        Cartitems: orderitems.items[i].ItemsList,
                      );
                    },
                  ),
                )
            ));
          }if(snapShot.data == null){
            return Text('nothing');
          }else{
            return Container();
          }
        } ,
      ),
      drawer: appDrawer(),
      drawerEdgeDragWidth: 200,
    );
  }
}
