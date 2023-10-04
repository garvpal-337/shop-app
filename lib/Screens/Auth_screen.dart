import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/Auth_provider.dart';
import '../Widgets/http_exceptions.dart';

enum AuthMode {
 LogIn,
 SignIn ,
}

class userAuthScreen extends StatefulWidget {
  static const routName ="/userauthscreen";
  const userAuthScreen({Key? key}) : super(key: key);

  @override
  State<userAuthScreen> createState() => _userAuthScreenState();
}

class _userAuthScreenState extends State<userAuthScreen> with SingleTickerProviderStateMixin {

  TextEditingController passController = TextEditingController();
   AuthMode _authMode = AuthMode.LogIn;
   var isLoading = false;
   var showpass = true;
   var passFocusNode = FocusNode();
   var cPassFocusNode = FocusNode();
   final _Form = GlobalKey<FormState>();
   Map<String,dynamic> authentication = {
     "Email" : "",
     "Password" : ""
   };

   // AnimationController? _Controller;
   // Animation<Size>? _animationheight;

 //   @override
 //  void initState() {
 //     super.initState();
 //
 //     _Controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
 //   _animationheight = Tween<Size>(begin: Size(double.infinity,380) ,end:  Size(double.infinity, 450)).animate(
 //   CurvedAnimation(parent: _Controller! , curve: Curves.linear));
 //
 // //  _animationheight!.addListener(() => setState(() {}));
 //  }

  // void dispose(){
  //    super.dispose();
  //    _Controller!.dispose();
  // }

   void showErrorDialoge(BuildContext ctx,String message){
     showDialog(context: ctx,
         builder: (ctxs){
          return AlertDialog(
            content: Text(message),
            title: Text("An error occured"),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(ctxs).pop();
              }, child: Text('Okay'))
            ],
          );
         });
   }
   Future <void> onSubmit() async{
     setState((){
       isLoading = true;
     });
     if(!_Form.currentState!.validate()){
       return;
     }
     _Form.currentState?.save();
     try {
       if (_authMode == AuthMode.SignIn) {
         await Provider.of<Auth>(context, listen: false).signUp(
             authentication["Email"],
             authentication["Password"]).then((_) {
           setState(() {
             isLoading = false;
           });
         });
         ;
       } else {
         await Provider.of<Auth>(context, listen: false).logIn(
             authentication["Email"],
             authentication["Password"]).then((_) {
           setState(() {
             isLoading = false;
           });
         });
       }
     } on HttpException catch(error){
       var errorMessage = 'Authentication failed. Please try again later';
       if(error.toString().contains("EMAIL_EXISTS")){
         errorMessage = "This Email is already exists";
       } else if(error.toString().contains("INVALID_EMAIL")){
         errorMessage = "Please enter valid Email address";
       } else if(error.toString().contains("WEAK_PASSWORD")){
         errorMessage = "Password is too weak";
       }else if(error.toString().contains("EMAIL_NOT_FOUND")){
         errorMessage = "Could not fount a user with this email";
       }else if(error.toString().contains("INVALID_PASSWORD")){
         errorMessage = "Incorrect Password";
       }
       showErrorDialoge(context, errorMessage);
     }catch (error) {
       var errorMessage = 'Could not Authenticate you. Please try again later';
       showErrorDialoge(context, errorMessage);
     }

   }


   void switchAuth(){
     _Form.currentState!.reset();
     passController.text = '';
     if(_authMode == AuthMode.LogIn){
       setState((){
         _authMode = AuthMode.SignIn;
       });
       //_Controller!.reverse();

     } else{
       setState((){
         _authMode = AuthMode.LogIn;
       });
      // _Controller!.forward();

     }
   }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: Image.asset('assets/png/campus_logo.webp',width: 150,),
      //   centerTitle: true,
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),

      body: Stack(
        children: [
            Container(
              child: Image.asset("assets/png/campus_shoes.webp",fit: BoxFit.cover,height: size.height * 1,width: size.width*1,),
            ),

          Center(
            child: Card(
              elevation: 8,
             shadowColor: Colors.black,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
               curve: Curves.linear,
               // height:  _authMode == AuthMode.LogIn ? size.height * 0.55: size.height * 0.65,
                height:  _authMode == AuthMode.LogIn ? 380: 460,

                 // height: _animationheight!.value.height,
              width: size.width*0.68,
                // constraints: BoxConstraints(
                //   minHeight: _animationheight!.value.height,
                // ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _Form,
                    child: Container(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            //alignment: Alignment.center,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child:  Image.asset('assets/png/campus_logo.webp',fit: BoxFit.fitWidth,),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: _authMode == AuthMode.LogIn ?"Enter Email" :"Email",
                              labelText:_authMode == AuthMode.LogIn ?"Email" :"Create Email",
                              contentPadding: EdgeInsets.all(15),
                              errorMaxLines: 2,
                              errorStyle: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value!.isEmpty ||  !value.contains("@")){
                               return 'Please enter valid Email address!';
                              }return null;
                            },
                            onFieldSubmitted: (_){
                              FocusScope.of(context).requestFocus(passFocusNode);
                            },
                            onSaved: (value){
                              authentication["Email"] = value!;
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password" ,
                              labelText: _authMode == AuthMode.LogIn ?"Password" : "Create Password",
                              contentPadding: EdgeInsets.all(15),
                              errorMaxLines: 2,
                              errorStyle: TextStyle(
                                fontSize: 10
                              ),
                              //suffixIcon: Icon(Icons.remove_red_eye_outlined),
                              // suffix: GestureDetector(
                              //   onTap: (){
                              //     setState((){
                              //       showpass = !showpass;
                              //     });
                              //   },
                              // )
                            ),
                            focusNode: passFocusNode,
                            obscureText: showpass,
                            obscuringCharacter: "*",
                            controller: passController,
                            validator: (value){
                              if(value!.isEmpty || value.length < 7){
                                return "password should have more then 8 characters";
                              }return null;
                            },
                            textInputAction: _authMode== AuthMode.SignIn ? TextInputAction.next : TextInputAction.done,
                            onFieldSubmitted: (_){
                              FocusScope.of(context).requestFocus(cPassFocusNode);
                            },
                            onSaved: (value){
                              authentication["Password"] = value!;
                            },
                          ),
                          SizedBox(height: 10,),

                          if(_authMode == AuthMode.SignIn) TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password" ,
                              labelText: "Confirm Password",
                              contentPadding: EdgeInsets.all(15),
                              errorMaxLines: 2,
                              errorStyle: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                            focusNode: cPassFocusNode,
                            textInputAction: TextInputAction.done,
                            validator: (value){
                              if(value != passController.text){
                                return "Password doesn't match";
                              }
                              if(value!.isEmpty){
                                return "Pllease enter password";
                              }
                              return null;
                            },
                            onSaved: (value){
                              authentication["Password"] = value!;
                            },
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(onPressed: ()=> onSubmit(),
                              child: Text(_authMode == AuthMode.LogIn? " Login" : "Sign up")),

                          //SizedBox(height: 10,),
                          TextButton(onPressed:()  {
                            switchAuth();
                          },
                              child: Text("${_authMode == AuthMode.LogIn? "SIGNUP" : "LOGIN"} INSTEAD")),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
