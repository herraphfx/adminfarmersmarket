import 'package:adminecomerce/commons/common.dart';
import 'package:adminecomerce/db/auth.dart';
import 'package:adminecomerce/db/users.dart';
import 'package:adminecomerce/screens/admin.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  UserServices _userServices = UserServices();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _confirmpasswordTextController = TextEditingController();
  bool loading = false;
  String groupValue = "male";
  bool hidePass = true;
  String gender;
  Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 3;
    return Scaffold(


      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Image.asset("images/logo.png", width: 100.0, height: 100.0,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.2),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: TextFormField(
                                  controller: _nameTextController,

                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Full Name",
                                    icon: Icon(Icons.person_outline),

                                  ),
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "The name field cannot be empty";
                                    } else{
                                      return null;
                                    }
                                  },
                                ),
                              ),

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.2),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    controller: _emailTextController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      icon: Icon(Icons.alternate_email),

                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        Pattern pattern =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                        RegExp regex = new RegExp(pattern);
                                        if (!regex.hasMatch(value))
                                          return 'Please make sure your email address is valid';
                                        else
                                          return null;
                                      }
                                    },
                                  ),
                                ),
                              ),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.2),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: ListTile(
                                  title: TextFormField(
                                    controller: _passwordTextController,
                                    obscureText: hidePass,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      icon: Icon(Icons.lock_outline),

                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Password field cannot be empty";
                                      } else if(value.length < 6){
                                        return "Password cannot be less than 6 characters";
                                      }else{
                                        return null;
                                      }
                                    },
                                  ),
                                  trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                    setState(() {
                                      hidePass = false;
                                    });
                                  }),
                                ),
                              ),

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.2),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: ListTile(
                                  title: TextFormField(
                                    controller: _confirmpasswordTextController,
                                    obscureText: hidePass,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password",
                                      icon: Icon(Icons.lock_outline),


                                    ),
                                    validator: (value){
                                      if(value.isEmpty){
                                        return "Password field cannot be empty";
                                      } else if(value.length < 6){
                                        return "Password cannot be less than 6 characters";
                                      }else if(_passwordTextController.text != value){
                                        return "Password does not match";
                                      }
                                      else{
                                        return null;
                                      }
                                    },
                                  ),
                                  trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                    setState(() {
                                      hidePass = false;
                                    });
                                  }),
                                ),

                              ),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.green,
                                elevation: 0.0,
                                child: MaterialButton(
                                  onPressed: () async {
                                    validateForm();
                                  },
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text("Register", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),
                                )

                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "I already have an account",textAlign: TextAlign.center ,style: TextStyle(color: Colors.deepOrange, fontSize: 16),
                                ),
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Or Sign Up With ", style: TextStyle(fontSize: 20,color: Colors.grey),),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                                  child: Material(
                                      child: MaterialButton(
                                          onPressed: () async {
                                            UserCredential user = await auth.googleSignIn();
                                            if(user == null){
                                              _userServices.createUser( {
                                                'name': user.user.displayName,
                                                'photo': user.user.photoURL,
                                                'email': user.user.email,
                                                'userId': user.user.uid,
                                              } );

                                              changeScreenReplacement(context, Admin());
                                            }
                                          },
                                          child: Image.asset("images/ggg.png", width: 60,)
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Visibility(

                visible: loading ?? true,

                child: Center(

                  child: Container(

                    alignment: Alignment.center,

                    color: Colors.white.withOpacity(0.9),

                    child: CircularProgressIndicator(

                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),

                    ),

                  ),

                ))

          ],

        ),
      ),



    );

  }

  valueChanged(e) {
    setState(() {
      if(e == "male"){
        groupValue = e;
        gender=e;
      }else if(e =="female"){
        groupValue = e;
        gender =e;
      }
    });
  }

  Future validateForm() async{
    FormState formState = _formKey.currentState;

    if(formState.validate()){
      formState.reset();
      var user = FirebaseAuth.instance.currentUser;
      if(user == null){
        firebaseAuth.createUserWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((user) => {
          _userServices.createUser(
              {
                "username": _nameTextController.text,
                "email": _emailTextController.text,
                "userId": user.user.uid,
                "gender": gender,
              }
          )
        }).catchError((err) => {print(err.toString())});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Admin()));
      }
    }
  }
}
