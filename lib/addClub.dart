import 'package:flutter/material.dart';
import 'package:loginpage/dashboard.dart' as Dashboard; // Alias dashboard.dart
import 'package:loginpage/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // Define your own MyApp class
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLUBS',
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddClub(title: 'Flutter Demo Home Page'),
    );
  }
}

class AddClub extends StatefulWidget {
  const AddClub({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddClub> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<AddClub> {
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

  void displayInfos() {
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
              'Your request for creating club is submitted !! ',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF940404),
        title: Text('REQUEST FOR CREATING CLUB',
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
                      'Once your information is submitted.The process of establishing the club will be carried out.',
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
                              "Content",
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
                    SizedBox(height: 20), // Add space between fields
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
                              "Creator Name",
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
                    SizedBox(height: 20), // Add space between fields
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Image Url",
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
                    SizedBox(height: 20), // Add space below password field
                    ElevatedButton(
                      onPressed: () {
                        displayInfos();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard.ActivityDashboard(
                              title: "Book Application",
                            ),
                          ),
                        );
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
