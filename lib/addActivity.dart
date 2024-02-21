import 'package:flutter/material.dart';
import 'package:loginpage/dashboard.dart';


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
      home: const AddActivity(title: 'ADD ACTIVITY',),
    );
  }
}

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddActivity> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddActivity> {
  int _counter = 0;
  final TextEditingController _activitynameController = TextEditingController();
  final TextEditingController _activityplaceController =
  TextEditingController();
  final TextEditingController _activitydateController = TextEditingController();
  final TextEditingController _activitycontentController =
  TextEditingController();

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
              'Your request for creating activity is submitted !! ',
              style: TextStyle(fontSize: 14),
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
        backgroundColor:Color(0xFF940404),
        title: Text("REQUEST FOR ADDING ACTIVITY",style: TextStyle(color: Colors.white, fontSize: 20.0)),
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

                  color:Color(0xFFFBE9E7),

                  // Dark red to lighter red gradient

                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      textAlign:TextAlign.center,
                      'Once your information is submitted to the admin, your activity will be announced.',
                      style: TextStyle(
                        color:Color(0xFF940404),

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
                    SizedBox(height: 20), // Add space between fields
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Activity Place ",
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
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Activity Date ",
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
                    ),//
                    const SizedBox(height: 20),// Add space between fields
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Activity Content ",
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
                    const SizedBox(height: 20),// Add space between fields
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Id Of Club ",
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
                    SizedBox(height: 20), // Add space below password field
                    ElevatedButton(
                      onPressed: () {
                        displayInfos();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityDashboard(
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