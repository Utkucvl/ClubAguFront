import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/adminPanel.dart';
import 'package:loginpage/adminPanelAdd.dart';
import 'package:loginpage/adminPanelAddActivity.dart';
import 'package:loginpage/loginpage.dart';

void main() {
  runApp(const MyApp());
}

void _showDetailOfActivity(BuildContext context, Activity exactActivity) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF940404),
          title: Text(
            "Details of Activity",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Color(0xFFFBE9E7),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF940404),
                      ),
                    ),
                    Text(
                      ' ${exactActivity.name}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Place:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF940404)),
                    ),
                    Text(
                      ' ${exactActivity.place}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Date:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF940404)),
                    ),
                    Text(
                      '${exactActivity.date}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'CONTENT',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF940404)),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      ' ${exactActivity.content}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
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
    fetchClubs();
    fetchActivities();
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out Confirmation'),
          content: Text(
            'Are you sure you want to log out?',
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
      final storage = FlutterSecureStorage();

      // Delete userId and accessToken
      await storage.delete(key: 'userId');
      await storage.delete(key: 'accessToken');

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
                'You have logged out!',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );

      // Navigate to MyHomePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(title: "Home Page"),
        ),
      );
    }
  }

  Future<void> fetchClubs() async {
    try {
      String? accessToken = await getAccessToken();
      if (accessToken != null) {
        const String apiUrl = 'http://10.0.2.2:8080/club';
        http.Response response = await http.get(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': accessToken,
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> clubsData = json.decode(response.body);
          List<Club> clubs = clubsData.map((data) {
            List<Activity> activities = (data['activities'] as List)
                .map((activity) => Activity(
                      id: activity['id'].toString(),
                      // Ensure 'id' is converted to a string
                      name: activity['name'],
                      place: activity['place'],
                      date: activity['date'],
                      content: activity['content'],
                      clubid: activity['clubid'],
                    ))
                .toList();

            return Club(
              id: data['id'].toString(),
              name: data['name'],
              content: data['content'],
              communication: data['communication'],
              usersId: (data['usersId'] as List).cast<int>(),
              activities: activities,
              photoUrl: data['photoUrl'],
            );
          }).toList();

          setState(() {
            allClubs = clubs;
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

  Future<void> removeActivityFromClub(
      int activityId, String activityname, String clubname) async {
    try {
      // Show confirmation dialog
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text(
              'Are you sure you want to remove $activityname activity from $clubname club?',
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
        // User confirmed, proceed with removal
        String? accessToken = await getAccessToken();
        if (accessToken != null) {
          String apiUrl =
              'http://10.0.2.2:8080/activity/' + activityId.toString();
          http.Response response = await http.delete(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': accessToken,
            },
          );

          if (response.statusCode == 204) {
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
                      '$activityname activity is removed from $clubname club!',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );

            setState(() {
              fetchActivities();
            });
          } else {
            print('Request failed with status: ${response.statusCode}');
          }
        } else {
          print('Access token is null');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Club? getClubById(int clubId) {
    print("IDD:${clubId}");
    // Search for the club by club ID
    Club? requiredClub;
    for (var club in allClubs) {
      if (int.parse(club.id) == clubId) {
        requiredClub = club;
        break;
      }
    }
    print(requiredClub);
    return requiredClub;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF940404),
        title: Text(
          "ACTIVITY MANAGEMENT",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Container(
        color: Color(0xFFFBE9E7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  itemCount: allActivities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final activity = allActivities[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
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
                          child: ListTile(
                            leading: Image.network(
                              getClubById(activity.clubid)!.photoUrl,
                              width: 50, // Adjust the width as needed
                              height: 50, // Adjust the height as needed
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                            title: Text(
                              activity.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              activity.date,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                removeActivityFromClub(
                                    int.parse(activity.id),
                                    activity.name,
                                    getClubById(activity.clubid)!.name);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFFFBE9E7),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 150,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF940404),
                  ),
                  child: Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.align_horizontal_left_sharp,
                  color: Color(0xFF940404),
                ),
                title: Text(
                  'All Clubs',
                  style: TextStyle(
                      color: Color(0xFF940404),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
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
                leading: Icon(Icons.local_activity, color: Color(0xFF940404)),
                title: Text(
                  'Activites',
                  style: TextStyle(
                      color: Color(0xFF940404),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
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
                leading: Icon(
                  Icons.add,
                  color: Color(0xFF940404),
                ),
                title: Text(
                  'Add Club',
                  style: TextStyle(
                      color: Color(0xFF940404),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
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
                leading: Icon(
                  Icons.add_box_outlined,
                  color: Color(0xFF940404),
                ),
                title: Text(
                  'Add Activity To Clubs',
                  style: TextStyle(
                      color: Color(0xFF940404),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
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
                leading: Icon(
                  Icons.logout,
                  color: Color(0xFF940404),
                ), // Icon for logout
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: Color(0xFF940404),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                onTap: () {
                  _logout(); // Call the logout method when tapped
                },
              ),
            ],
          ),
        ),
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
      required this.photoUrl});
}
