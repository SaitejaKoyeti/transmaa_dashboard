import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transmaa_dashboard/Email_login/register.dart';
import '../admin.dart';
import 'forgot_password.dart';


class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  State<EmailLogin> createState() => _EmailLoginState();
  void navigateToEmailLogin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>EmailLogin()));
  }
}

class _EmailLoginState extends State<EmailLogin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/images/backimage1.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: 1600),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 50),
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        height: 220,
                        width: 330,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      alignment: Alignment.center,
                      child:Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue[900]),),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        autofocus: false,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email,
                              color: Colors.white,),
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 20,color: Colors.white),

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            errorStyle:
                            TextStyle(fontSize: 15)),
                        controller: emailController,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        obscureText: _isObscure,
                        autofocus: false,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password,color: Colors.white,),
                            suffixIcon: IconButton(color: Colors.white,
                              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 20,color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            errorStyle: TextStyle(fontSize: 15)),
                        controller: passwordController,
                      ),

                    ),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16, color: Colors.orangeAccent, fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {

                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text)
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: "Sign in successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 2,
                                      fontSize: 16.0

                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
                                }).onError((error, stackTrace) {
                                  print("Error: ${error.toString()}");
                                });
                              },
                              child: const Text("Login",
                                  style: TextStyle(fontSize: 18.0,color: Colors.black))),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPasswordScreen()));
                            },
                            child: const Text(
                              'Forget Password ?',
                              style: TextStyle(fontSize: 16, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

