import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/adminPanel.dart';
import 'package:loginpage/dashboard.dart';
import 'package:loginpage/filteredclubs.dart';
import 'package:loginpage/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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
        print(accessToken);
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'userId', value: userId);
        print(accessToken);
        if(username == "admin"){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminPanel(title: "Register Page")));
        }
        else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActivityDashboard(title: "Register Page")));
        }
        _usernameController.clear();
        _passwordController.clear();

      } else {
        print('Request failed with status: ${response.statusCode}');
        _usernameController.clear();
        _passwordController.clear();
      }
    } catch (e) {
      // Handle any errors that might occur
      print('Error: $e');
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.red.shade900,
                      Colors.red.shade400
                    ], // Dark red to lighter red gradient
                  ),
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome to the Login Page',
                      style: TextStyle(
                        fontSize: 24, // Larger font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Rounded corners
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Add space between fields
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Rounded corners
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Add space below password field
                    ElevatedButton(
                      onPressed: () {
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        _login(username, password);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Rounded corners for button
                        ),
                        primary: Colors.white,
                        // Background color of the button
                        elevation: 10,
                        // Elevation, gives a shadow effect
                        shadowColor: Colors.red,
                        // Shadow color
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        // Button padding
                        textStyle: TextStyle(
                            fontSize: 18), // Text style of the button text
                      ),
                      child: Text('Login'),
                      // Button text
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
                                    RegisterPage(title: "Register Page")));
                      },
                      child: Text(
                        'Do not you have account , register to click',
                        style: TextStyle(
                            color: Colors.white // Add underline to the text
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
