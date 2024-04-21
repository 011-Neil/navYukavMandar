import 'package:flutter/material.dart';

import 'package:http/io_client.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:navyuvakmandar/models/login_screen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}
  Future<void> _logout(BuildContext context) async {
  try {
     final ioc = new HttpClient();
        ioc.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        final http = new IOClient(ioc);
    final response = await http.post(
      Uri.https("10.0.2.2:7069","/api/user/logout"), // Replace with your logout API endpoint
    );

    if (response.statusCode == 200) {
      // Handle successful logout
      // For example, navigate back to the login page
      print('Logout successful!');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
    } else {
      // Handle failed logout
      // Display an error message to the user
      print('Logout failed: ${response.body}');
    }
  } catch (error) {
    // Handle network errors or other exceptions
    print('An error occurred during logout: $error');
  }
}

    class _SideMenuState extends State<SideMenu> {
      @override
      Widget build(BuildContext context) {
        return Drawer(
          backgroundColor: Color(0xff102733) ,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('NavYuk Mandar'),
                accountEmail: Text('Navyukmandar@gmail.com'),
                decoration: BoxDecoration(
                      color:  Color.fromARGB(255, 2, 30, 45),
                ),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset("assets/logo.png",
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover
                    ),
                  )
              )
            ),
            ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: null
              ),
              ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.calendar_today),
                title: Text('Aarti Calendar'),
                onTap: null
              ),
              ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.book),
                title: Text('Events'),
                onTap: () {

                },
              ),
                ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.payment),
                title: Text('Payment'),
                onTap: null
              ),
                ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: null
              ),
                ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                onTap: () {
                  _logout(context);
                },
              )
          ],
        )
    );
}
}