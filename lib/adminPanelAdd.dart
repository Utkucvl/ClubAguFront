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
  final TextEditingController _photoUrlController = TextEditingController();

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

  Future<void> _addClub(String name, String content, String communication,
      String createrName, String photoUrl) async {
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
          'photoUrl': photoUrl
        };

        // Encode the data to JSON
        String body = json.encode(data);

        // Show confirmation dialog
        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Adding Confirmation'),
              content: Text(
                'Are you sure you want to add the club $name to university',
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User confirmed
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User canceled
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          // User confirmed, proceed with club addition
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
                      '$name named club is added to our university!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Clear text controllers after a successful request
            _clubnameController.clear();
            _contentController.clear();
            _communicationController.clear();
            _creaternameController.clear();
            _photoUrlController.clear();

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
            _photoUrlController.clear();
          }
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
        backgroundColor: Color(0xFFB71C1C),
        title: Text(
          "ADD CLUB",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
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
                  color: Color(0xFFFBE9E7),
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 1.0),
                    Text(
                      'When you enter information, the event will be shared with users',
                      style: TextStyle(
                        color: Color(0xFF940404),
                        fontSize: 20, // Larger font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Club Name ",
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
                          controller: _clubnameController,
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
                    SizedBox(height: 20), // Add space between fields
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Content ",
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
                          controller: _contentController,
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
                    SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Communication ",
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
                          controller: _communicationController,
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
                    SizedBox(height: 20), // Add space between fields
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Creater Name ",
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
                          controller: _creaternameController,
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
                    SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Photo Url ",
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
                          controller: _photoUrlController,
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
                    SizedBox(height: 20), // Add space below password field
                    ElevatedButton(
                      onPressed: () {
                        String name = _clubnameController.text;
                        String content = _contentController.text;
                        String communication = _communicationController.text;
                        String createrName = _creaternameController.text;
                        String photoUrl = _photoUrlController.text;
                        _addClub(name, content, communication, createrName,
                            photoUrl);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF940404),
                        padding: const EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
