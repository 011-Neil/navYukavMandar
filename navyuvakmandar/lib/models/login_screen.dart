import 'package:flutter/material.dart';
import 'package:navyuvakmandar/models/signup_page.dart';
import 'package:navyuvakmandar/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

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
      print('inside try');
      final ioc = new HttpClient();
        ioc.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final http = new IOClient(ioc);
      print(ioc);
      final response = await http.post(
        new Uri.http("10.0.2.2:5028","/api/user/login"),
        body: jsonEncode({"username": username, "password": password}),
        headers: {'Content-Type': 'application/json'}
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
        print('Login failed: ${response.body}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
            backgroundColor: Colors.red,
          ),
        );
      print('An error occurred: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
    // Add the rest of your widget tree below

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset( // Your logo image
                      'assets/logo.png',
                       height: 50, // Adjust height as needed
                    ),
                    SizedBox(height: 20,),
                    Text("Login to your account",
                    style: TextStyle(
                      fontSize: 15,
                    color:Colors.white),)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      inputFile(label: "Email or Username",controller: emailController),
                      inputFile(label: "Password", obscureText: true,controller: passwordController),
                    ],
                  ),
                ),
                  Padding(padding:
                  EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration:
                        BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.yellow),
                            top: BorderSide(color: Colors.yellow),
                            left: BorderSide(color: Colors.yellow),
                            right: BorderSide(color: Colors.yellow),

                          )



                        ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          // Call the login function here
                          _login(context);
                        },
                        color: Color(0xff0095FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),

                        ),
                        child: Text(
                          "Login", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,

                        ),
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
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                      child: Text(
                        " Sign up",
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
            ))
          ],
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
