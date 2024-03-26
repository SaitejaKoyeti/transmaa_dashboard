import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';


class ForgotPasswordScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(
        email: _emailController.text,
      );
      // Display a success message to the user
      print('Password reset email sent successfully');
    } catch (e) {
      // Display an error message to the user
      print('Error sending password reset email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/images/backimage.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 50),
              child: Column(
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
                  Container(
                    child: Text('Forgot Password',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                  ),
                  SizedBox(height: 30,),
                  TextField(style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email,color: Colors.white,),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 20,color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        errorStyle:
                        TextStyle(fontSize: 15)
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _sendPasswordResetEmail();
                      Navigator.push(
                          context,MaterialPageRoute(
                          builder: (context)=> EmailLogin())
                      );
                    },
                    child: Text('Reset Password'),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}