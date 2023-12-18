import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loginpage/adminPanel.dart';

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
      home: const AdminPanelAdd(title: 'Flutter Demo Home Page'),
    );
  }
}

class AdminPanelAdd extends StatefulWidget {
  const AdminPanelAdd({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AdminPanelAdd> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminPanelAdd> {
  int _counter = 0;
  final TextEditingController _clubnameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _communicationController =
  TextEditingController();
  final TextEditingController _creaternameController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  Future<String?> getAccessToken() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    return accessToken;
  }

  Future<void> _addClub(String name, String content, String communication, String createrName) async {
    String? accessToken = await getAccessToken();
    // API endpoint for adding a club
    const String apiUrl = 'http://10.0.2.2:8080/club';

    if (accessToken != null) {
      try {
        // Create a Map to hold the request body data
        Map<String, dynamic> data = {
          'name': name,
          'content': content,
          'communication': communication,

        };

        // Encode the data to JSON
        String body = json.encode(data);

        // Make POST request
        http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': accessToken,
          },
          body: body,
        );

        // Check the response status code
        if (response.statusCode == 201) {
          final storage = FlutterSecureStorage();
          Map<String, dynamic> responseData = json.decode(response.body);

          // Clear text controllers after a successful request
          _clubnameController.clear();
          _contentController.clear();
          _communicationController.clear();
          _creaternameController.clear();

          // Navigate after successful submission
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPanel(title: "Register Page"),
            ),
          );
        } else {
          print('Request failed with status: ${response.statusCode}');
          _clubnameController.clear();
          _contentController.clear();
          _communicationController.clear();
          _creaternameController.clear();
        }
      } catch (e) {
        // Handle any errors that might occur
        print('Error: $e');
      }
    }
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
                      'Welcome to request page of adding club to our university , be aware of that these informations will be mailed to rector!!',
                      style: TextStyle(
                        fontSize: 16, // Larger font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _clubnameController,
                      decoration: InputDecoration(
                        labelText: 'Club Name',
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
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
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
                      controller: _communicationController,
                      decoration: InputDecoration(
                        labelText: 'Communication',
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
                      controller: _creaternameController,
                      decoration: InputDecoration(
                        labelText: 'Creater Name',
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
                        String name = _clubnameController.text;
                        String content = _contentController.text;
                        String communication = _communicationController.text;
                        String createrName = _creaternameController.text;
                        _addClub(name, content, communication, createrName);
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
                      child: Text('Add Club To University'),
                      // Button text
                    ),
                    const SizedBox(
                      height: 10,
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
