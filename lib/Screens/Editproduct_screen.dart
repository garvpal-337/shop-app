import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/Product_provider.dart';
import 'package:shopapp/Providers/product_class_provider.dart';

class editProductScreen extends StatefulWidget {
  static const routeName ='/editproductscreen';
  const editProductScreen({Key? key}) : super(key: key);

  @override
  State<editProductScreen> createState() => _editProductScreenState();
}

class _editProductScreenState extends State<editProductScreen> {

  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _imageurlFocusNode = FocusNode();
  final _imageurlController = TextEditingController();
  final _form = GlobalKey<FormState>();
   String title = '';
   var isLoading = false;
  var _editedProduct = product(
      id: '',
      title: '',
      description: '',
      imageUrl: '',
      price: 0);

  var _isInit = true;

  var  _initValue  = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : '',
  };

  @override
  void initState() {
    _imageurlFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<Object,String>;
      final productId = arguments["ID"];
      title = arguments["TITLE"]!;
      if(productId != "null"){
        _editedProduct = Provider.of<Products>(context).findById(productId!);
        _initValue = {
          'title' :  _editedProduct.title,
          'description' : _editedProduct.description,
          'price' : _editedProduct.price.toString(),
          'imageUrl' : '',
        };
        _imageurlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    _imageurlFocusNode.removeListener(_updateImageURL);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageurlFocusNode.dispose();
    _imageurlController.dispose();

    super.dispose();
  }



  void _updateImageURL(){
    if(!_imageurlFocusNode.hasFocus){
      if(!_imageurlController.text.startsWith("http") && !_imageurlController.text.startsWith("https")){
        return ;
      }
      setState((){});
    }
  }

  void _saveForm() async {
    bool isValidate = _form.currentState!.validate();
    if(!isValidate){
      return ;
    }
       _form.currentState?.save();
    setState((){
      isLoading = true;
    });
    if(_editedProduct.id.isNotEmpty){
     try {
       await Provider.of<Products>(context, listen: false).updateProduct(
           _editedProduct.id, _editedProduct);
     } catch (error){
       await showDialog<Null>(context: context, builder: (ctx){
         return AlertDialog(
           content: Text('Something went wrong'),
           title: Text('An error occurred'),
           actions: [
             TextButton(onPressed: (){
               Navigator.of(context).pop();
             },
                 child: Text('okay'))
           ],
         );
       });
     } finally {
       ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Successfully updated")));
     }
    }else {
    try {
      await Provider.of<Products>(context, listen: false).addPoduct(
          _editedProduct);
    } catch (error){
      await showDialog<Null>(context: context, builder: (ctx){
        return AlertDialog(
          content: Text('Something went wrong'),
          title: Text('An error occurred'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            },
                child: Text('okay'))
          ],
        );
      });
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully added")));

    }
    }
    setState((){
      isLoading = false;
    });
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/png/campus_logo.webp',width: 150,),
        centerTitle: true,
        actions:[
          IconButton(onPressed:(){
            _saveForm();
          },
              icon: Icon(Icons.save_sharp))
        ]
      ),
      body:isLoading ? Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      ):Center(
        child: Container(
          alignment: Alignment.center,
          height: 550,
          width: 350,
          child: Card(
            elevation: 6,
            child: Column(
              children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor
                          ),),
                          SizedBox(width: 5,),
                          Icon(Icons.edit_note,color: Theme.of(context).primaryColor,size: 40,)
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  flex: 9,
                  child: Form(
                      key: _form,
                      child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        children: [
                           TextFormField(
                             decoration: InputDecoration(
                               border: OutlineInputBorder(),
                               labelText: 'title',
                             ),
                             initialValue: _initValue['title'],
                             textInputAction: TextInputAction.next,
                             onFieldSubmitted: (_){
                               FocusScope.of(context).requestFocus(_priceFocusNode);
                             },
                             onSaved: (String? value){
                               _editedProduct = product(id: _editedProduct.id,
                                   isFavorite: _editedProduct.isFavorite,
                                   title: value!,
                                   description:_editedProduct.description,
                                   imageUrl:_editedProduct.imageUrl,
                                   price:_editedProduct.price,
                                   );
                             },
                             validator: (value){
                               if(value!.isEmpty){
                                 return 'Please enter title of the product';
                               } return null;
                             },
                           ),
                          SizedBox(height: 5,),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Price',
                            ),
                            initialValue: _initValue['price'],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_){
                              FocusScope.of(context).requestFocus(_imageurlFocusNode);
                              },
                            onSaved: (String? value){
                              _editedProduct = product(id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description:_editedProduct.description,
                                  imageUrl:_editedProduct.imageUrl,
                                  price:double.parse(value!));
                            },
                              validator: (value){
                              if(value!.isEmpty){
                                return 'Please enter price of the product';
                              }
                              if(double.tryParse(value) == null ){
                                return "Please enter Valid amount";
                              }
                              if(double.parse(value) <= 0){
                                return 'Please enter number greater then zero.';
                              }
                              return null;
                              },

                          ),
                          SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                            Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                              ),
                              child: _imageurlController.text.isEmpty? Text('Enter URL') :
                              ClipRRect(
                                child: Image.network(_imageurlController.text,fit: BoxFit.cover,),
                              ),
                            ),
                              SizedBox(width: 5,),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Image URL',
                                  ),
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.url,
                                  controller: _imageurlController,
                                  focusNode: _imageurlFocusNode,

                                  onFieldSubmitted: (_){
                                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                                  //   // setState((){
                                  //   //   imageurl = _imageurlController.text;
                                  //   // });
                                  //
                                    },
                                  onSaved: (String? value){
                                    _editedProduct = product(id: _editedProduct.id,
                                        isFavorite: _editedProduct.isFavorite,
                                        title: _editedProduct.title,
                                        description:_editedProduct.description,
                                        imageUrl:value!,
                                        price:_editedProduct.price);
                                  },
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Please enter Image URL of the product';
                                    }
                                    if(!value.startsWith("http") && !value.startsWith("https")){
                                      return "Please enter valid url !";
                                    }
                                    // if(!value.endsWith(".jpg") && !value.endsWith(".png") && !value.endsWith(".jpeg")){
                                    //   return "Please Enter valid url";
                                    //}
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),

                          SizedBox(height: 5,),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description',
                            ),
                            initialValue: _initValue['description'],
                            textInputAction: TextInputAction.newline,
                            maxLines: 10,
                            focusNode: _descriptionFocusNode,
                            onSaved: (String? value){
                              _editedProduct = product(id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description:value!,
                                  imageUrl:_editedProduct.imageUrl,
                                  price:_editedProduct.price);
                            },
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please enter description of the product';
                              }
                              if(value.length < 10){
                                return "Please enter more then 10 characters";
                              }
                              return null;
                            },
                          ),


                        ],
                      )),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
