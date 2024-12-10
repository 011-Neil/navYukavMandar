import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:navyuvakmandar/home.dart';
import 'package:navyuvakmandar/models/signup_page.dart';
class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String username = emailController.text;
    print(username);
    String password = passwordController.text;
    print(password);

    // Replace 'api/login' with the actual login endpoint

    try {
      print("inside try");
      final ioc = new HttpClient();
        ioc.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final http = new IOClient(ioc);
      final response = await http.post(
        new Uri.https("10.0.2.2:7069","/api/user/login"),
        body: jsonEncode({"username": username, "password": password}),
        headers: {'Content-Type': 'application/json'},
      );

      print(response);

      if (response.statusCode == 200) {
        // Handle successful login
        // Navigate to the next screen, show a success message, etc.
        print('Login successful!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Handle failed login
        // Display an error message to the user
        print('Login failed: ${response.body}');
      }
    } catch (error) {
      print('inside catch');
      // Handle network errors or other exceptions
      print('An error occurred: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NavYuk Mandal",style: TextStyle(color: Color(0xffFCCD00)),),
        backgroundColor: Color(0xff102733),
      ),
      backgroundColor: Color(0xff102733),
      body:
       Padding(
        padding:EdgeInsets.fromLTRB(20,0, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
              padding: const EdgeInsets.only(top: 2), // Adjust the top padding here
              child: Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 70,
                ),
              ),
            ),
            SizedBox(height: 20),
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            SizedBox(height: 20),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 20),
            MyButton(
              onTap: () {
                // Handle sign in logic here
                // Example:
                // signIn(emailController.text, passwordController.text);

                _login(context);
              },
            ),
            SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to the registration page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Register",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
