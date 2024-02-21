import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:loginpage/adminPanel.dart';
import 'package:loginpage/dashboard.dart';
import 'package:loginpage/register.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(String username, String password) async {
    // API endpoint for login
    const String apiUrl = 'http://10.0.2.2:8080/auth/login';

    try {
      // Create a Map to hold the request body data
      Map<String, String> data = {
        'userName': username,
        'password': password,
      };

      // Encode the data to JSON
      String body = json.encode(data);

      // Make POST request

      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        final storage = FlutterSecureStorage();
        Map<String, dynamic> responseData = json.decode(response.body);
        String accessToken = responseData['accessToken'];
        String userId = responseData['userId'].toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'You have successfully logged in !',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'userId', value: userId);
        print(accessToken);
        if (username == "admin") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminPanel(title: "Register Page")));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ActivityDashboard(title: "Register Page")));
        }
        _usernameController.clear();
        _passwordController.clear();
      } else {
        print('Request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Login failed  . Please check your credantials',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
        //meaningful message to user that shows he or she could not logged in
        _usernameController.clear();
        _passwordController.clear();
      }
    } catch (e) {
      // Handle any errors that might occur
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'An error occurred. Please try again.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFBE9E7),
                    Color(0xFFFBE9E7),
                  ],
                ),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Abdullah_G%C3%BCl_University_logo.svg/330px-Abdullah_G%C3%BCl_University_logo.svg.png',
                    height: 125,
                    width: 125,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "WELCOME",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'CLUB AGU',
                    style: TextStyle(
                      color: Color(0xFFB71C1C),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Text(
                            "Username: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 275,
                    height: 40,
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: '',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Text(
                            "Password:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 275,
                    height: 40,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      _login(username, password);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color(0xFFB71C1C),
                      elevation: 10,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    child: Container(
                      width: 75,
                      child: const Center(
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const RegisterPage(title: "Register Page"),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'If you don\'t have an account, please ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In.',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
