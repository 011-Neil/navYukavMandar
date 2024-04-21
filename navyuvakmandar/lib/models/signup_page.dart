import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:navyuvakmandar/models/login_screen.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


   Future<void> _register(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;
    String email = emailController.text;

    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = new IOClient(ioc);
      final response = await http.post(
        new Uri.https("10.0.2.2:7069", "/api/user/register"),
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print(response);

      if (response.statusCode == 200) {
        // Handle successful registration
        // For example, show a success message and navigate to the login page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to the login page
      } else {
        // Handle failed registration
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('An error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xff102733),
      appBar: AppBar(
      elevation: 0,
      backgroundColor: Color(0xff102733),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.white,
        ),
      ),
      titleSpacing: 0, // Set title spacing to 0
      title: Row( // Use Row to align logo and title horizontally
        children: [
          Image.asset( // Your logo image
            'assets/logo.png',
            height: 24, // Adjust height as needed
          ),
          SizedBox(width: 8), // Add some spacing between logo and title
          Text(
                "NavYuk",
                style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800),
              ),
          Text(
            "Mandal",
            style: TextStyle(
                color: Color(0xffFFA700),
                fontSize: 25,
                fontWeight: FontWeight.w800),
          )
        ],
      ),
     ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.yellow),),
                    SizedBox(height: 20,),
                  Text("Create an account, It's free ",
                    style: TextStyle(
                        fontSize: 15,
                        color:Colors.white),)

                ],
              ),
              Column(
                children: <Widget>[
                  inputFile(label: "Username",controller: usernameController),
                  inputFile(label: "Email",controller: emailController),
                  inputFile(label: "Password",controller: passwordController, obscureText: true),
                  inputFile(label: "Confirm Password ",controller: confirmPasswordController, obscureText: true),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration:
                BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),



                    )

                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {_register(context);},
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),

                  ),
                  child: Text(
                    "Sign up", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,

                  ),
                  ),

                ),



              ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?",style: TextStyle(color: Colors.white),),
                    GestureDetector(
                        onTap: () {
                          // Navigate to the sign-up page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                      child: Text(
                        " Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),



            ],

          ),


        ),

      ),

    );
  }
}



// we will be creating a widget for text field
Widget inputFile({
  required String label,
  bool obscureText = false,
  required TextEditingController controller, // Mark controller as required
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}
