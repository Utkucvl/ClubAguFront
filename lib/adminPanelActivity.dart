import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/activityDetails.dart';
import 'package:loginpage/addActivity.dart';
import 'package:loginpage/addClub.dart';
import 'package:loginpage/adminPanel.dart';
import 'package:loginpage/adminPanelAdd.dart';
import 'package:loginpage/adminPanelAddActivity.dart';
import 'package:loginpage/filteredclubs.dart';
import 'package:loginpage/joinclub.dart';
import 'package:loginpage/main.dart';

void main() {
  runApp(const MyApp());
}

void _showDetailOfActivity(BuildContext context , Activity exactActivity) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Details of Activity: ${exactActivity.name}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Club Id Of Owner This Activity: ${exactActivity.clubid}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Name: ${exactActivity.name}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Content: ${exactActivity.content}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Place: ${exactActivity.place}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Date: ${exactActivity.date}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AdminPanelActivity(title: 'Book Application'),
    );
  }
}

class AdminPanelActivity extends StatefulWidget {
  const AdminPanelActivity({super.key, required this.title});

  final String title;

  @override
  State<AdminPanelActivity> createState() => _MyHomePageState();
}

Future<String?> getUserId() async {
  final storage = FlutterSecureStorage();
  String? userId = await storage.read(key: 'userId');
  return userId;
}

Future<String?> getAccessToken() async {
  final storage = FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'accessToken');
  return accessToken;
}

class _MyHomePageState extends State<AdminPanelActivity> {
  List<Club> allClubs = [];
  List<Activity> allActivities = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> _logout() async {
    final storage = FlutterSecureStorage();

    // Delete userId and accessToken
    await storage.delete(key: 'userId');
    await storage.delete(key: 'accessToken');

    // Navigate to MyHomePage
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(title: "Home Page")),
    );
  }

  Future<void> fetchActivities() async {
    try {
      String? accessToken = await getAccessToken();
      if (accessToken != null) {
        const String apiUrl = 'http://10.0.2.2:8080/activity';
        http.Response response = await http.get(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': accessToken,
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> activitiesData = json.decode(response.body);
          List<Activity> activities = activitiesData
              .map((activity) => Activity(
            id: activity['id'].toString(),
            name: activity['name'],
            place: activity['place'],
            date: activity['date'],
            content: activity['content'],
            clubid: activity['clubid'],
          ))
              .toList();

          setState(() {
            allActivities = activities;
          });
          // Process the clubs list
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> removeActivityFromClub(int activityId) async {
    try {
      String? accessToken = await getAccessToken();
      if (accessToken != null) {
        String apiUrl = 'http://10.0.2.2:8080/activity/' + activityId.toString();
        http.Response response = await http.delete(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': accessToken,
          },
        );

        if (response.statusCode == 204) {
          print("sa");
          setState(() {
            fetchActivities();
          });
          // Process the clubs list
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    itemCount: allActivities.length,
                    itemBuilder: (BuildContext context, int index) {
                      final activity = allActivities[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 10.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            _showDetailOfActivity(context, activity);
                          },
                          child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      activity.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      removeActivityFromClub(
                                          int.parse(activity.id));
                                    },
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Clubs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPanel(
                      title: "Book Application",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Activites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPanelActivity(
                      title: "Book Application",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Club To University'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPanelAdd(
                      title: "Book Application",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Activity To Clubs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPanelAddActivity(
                      title: "Book Application",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout), // Icon for logout
              title: Text('Logout'),
              onTap: () {
                _logout(); // Call the logout method when tapped
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminPanel(
                      title: "Book Application",
                    )),
              );
            }
            if (_currentIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminPanelActivity(
                      title: "Book Application",
                    )),
              );
            }
            if (_currentIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminPanelAdd(
                      title: "Book Application",
                    )),
              );
            }
            if (_currentIndex == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminPanelAddActivity(
                      title: "Book Application",
                    )),
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Club',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Activity',
          ),
        ],
      ),
    );
  }
}

class Activity {
  final String id;
  final String name;
  final String place;
  final String date;
  final String content;
  final int clubid;

  const Activity(
      {required this.id,
        required this.name,
        required this.place,
        required this.date,
        required this.content,
        required this.clubid});
}

class Club {
  final String id;
  final String name;
  final String content;
  final String communication;
  final List<int> usersId;
  final List<Activity> activities;
  final String photoUrl;

  const Club(
      {required this.id,
        required this.name,
        required this.content,
        required this.communication,
        required this.usersId,
        required this.activities,
        required this.photoUrl
      });
}
