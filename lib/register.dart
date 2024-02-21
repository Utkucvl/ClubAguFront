import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/loginpage.dart';


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
        primarySwatch: Colors.red,
      ),
      home: const RegisterPage(title: 'SIGN IN'),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentIndex = 0;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _register(String username, String password) async {
    // API endpoint for login
    const String apiUrl = 'http://10.0.2.2:8080/auth/register';

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
      if (response.statusCode == 201) {
        final storage = FlutterSecureStorage();
        Map<String, dynamic> responseData = json.decode(response.body);
        _usernameController.clear();
        _passwordController.clear();
        _emailController.clear();
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
                  'You have successfully signed in !',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(title: "Home Page")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This username is already in use,',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'please try to sign in with another username!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );

        _usernameController.clear();
        _passwordController.clear();
        _emailController.clear();
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
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "                 SIGN IN",
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF940404),
      ),
      body: Container(
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10),
                Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Abdullah_G%C3%BCl_University_logo.svg/330px-Abdullah_G%C3%BCl_University_logo.svg.png',
                  height: 50,
                  width: 50,
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'CLUB AGU',
                    style: TextStyle(
                      color: Color(0xFFB71C1C),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
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
                          "E-mail: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 40,
                    child: TextFormField(
                      controller: _emailController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 40,
                    child: TextFormField(
                      controller: _usernameController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Text(
                          "Password: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 40,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 125),
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        String username = _usernameController.text;
                        String password = _passwordController.text;
                        _register(username, password);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF940404),
                        padding: const EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


