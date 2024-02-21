import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loginpage/adminPanelActivity.dart';

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
      home: const AdminPanelAddActivity(title: 'Flutter Demo Home Page'),
    );
  }
}

class AdminPanelAddActivity extends StatefulWidget {
  const AdminPanelAddActivity({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<AdminPanelAddActivity> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminPanelAddActivity> {
  int _counter = 0;
  final TextEditingController _activitynameController = TextEditingController();
  final TextEditingController _activitycontentController =
      TextEditingController();
  final TextEditingController _activityplaceController =
      TextEditingController();
  final TextEditingController _activitydateController = TextEditingController();
  final TextEditingController _clubidController = TextEditingController();

  Future<String?> getAccessToken() async {
    final storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: 'accessToken');
    return accessToken;
  }

  Future<void> _addActivity(String name, String place, String date,
      String content, int clubid) async {
    String? accessToken = await getAccessToken();
    // API endpoint for adding an activity
    const String apiUrl = 'http://10.0.2.2:8080/activity';

    if (accessToken != null) {
      try {
        // Create a Map to hold the request body data
        Map<String, dynamic> data = {
          'name': name,
          'content': content,
          'place': place,
          'date': date,
          'clubid': clubid
        };

        // Encode the data to JSON
        String body = json.encode(data);

        // Show confirmation dialog
        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Activity Confirmation'),
              content: Text(
                'Are you sure you want to add the activity $name to the club with ID $clubid?',
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
          // User confirmed, proceed with activity addition
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
                      '$name activity is added to the club with ID $clubid!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Clear text controllers after a successful request
            _activitynameController.clear();
            _activitydateController.clear();
            _activityplaceController.clear();
            _activitycontentController.clear();
            _clubidController.clear();

            // Navigate after successful submission
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AdminPanelActivity(title: "Register Page"),
              ),
            );
          } else {
            print('Request failed with status: ${response.statusCode}');
            _activitynameController.clear();
            _activitydateController.clear();
            _activityplaceController.clear();
            _activitycontentController.clear();
            _clubidController.clear();
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
        backgroundColor: Color(0xFF940404),
        title: Text('Add Activity To Clubs',
            style: TextStyle(color: Colors.white, fontSize: 20.0)),
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
                    Text(
                      textAlign: TextAlign.center,
                      'When you enter information, the event will be shared with users',
                      style: TextStyle(
                        color: Color(0xFF940404),

                        fontSize: 20, // Larger font size
                        fontWeight: FontWeight.bold, // Bold text
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
                              "Activity Name ",
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
                          controller: _activitynameController,
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
                              "Activity Content",
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
                          controller: _activitycontentController,
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
                              "Activity Place",
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
                          controller: _activityplaceController,
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
                              "Activty Date",
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
                          controller: _activitydateController,
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
                              "Club Id",
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
                          controller: _clubidController,
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
                        String name = _activitynameController.text;
                        String content = _activitycontentController.text;
                        String place = _activityplaceController.text;
                        String date = _activitydateController.text;
                        int clubid = int.parse(_clubidController.text);
                        _addActivity(name, place, date, content, clubid);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF940404),
                        padding: const EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Add Activity To Club',
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
