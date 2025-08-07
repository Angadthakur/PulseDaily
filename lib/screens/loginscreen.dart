import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  TextEditingController usermailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/3.2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0XFFc2e59c), Color(0XFF64b3f4)],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      105.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Login!",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        "Login to your account!!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
        
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 25.0,
                        horizontal: 20.0,
                      ),
        
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
        
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 30.0,
                            horizontal: 20.0,
                          ),
                          //height: MediaQuery.of(context).size.height / 1.7,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),

        
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Padding(
                                    padding:const EdgeInsets.only(top: 20) 
                                    ),

                                Text(
                                  "Email",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  controller: usermailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter your E-mail";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: "Enter email ID",
                                    prefixIcon: Icon(Icons.mail_outline),
                                  ),
                                ),
        
                                SizedBox(height: 35),

                                Text(
                                    "Password",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                ),
                                TextFormField(
                                    controller: userpasswordcontroller,
                                    validator: (value) {
                                      if(value== null || value.isEmpty){
                                        return "Please Enter your password";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: "Enter password",
                                    prefixIcon: Icon(Icons.password_outlined),
                                 ),
                                 obscureText: true,
                            ),
                            Container(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                    onTap: () {
                                      //TODO
                                    },
                                    child: Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54
                                        ),
                                    ),
                                ),
                            ),
                            SizedBox(height: 70),

                            GestureDetector(
                                onTap: () {
                                  if(_formkey.currentState!.validate()){
                                    //
                                  }
                                },

                                child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        width: 130,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color:Color(0XFF64b3f4),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Center(
                                            child: Text(
                                                "Login",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                ),
                                        ),
                                    ),
                                ),
                            )
                            
                            
                            
                            
                            
                            ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16
                                ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  //TODO
                                },
                                child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                                ),
                            )
                        ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
