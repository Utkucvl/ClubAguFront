import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/activityDetails.dart';
import 'package:loginpage/addActivity.dart';
import 'package:loginpage/addClub.dart';
import 'package:loginpage/dashboard.dart';
import 'package:loginpage/filteredclubs.dart';
import 'package:loginpage/joinclub.dart';
import 'package:loginpage/main.dart';

void main() {
  runApp(const MyApp());
}

class ClubDetail extends StatefulWidget {
  const ClubDetail({
    super.key,
    required this.exactClub,
  });

  final Club exactClub;

  @override
  State<StatefulWidget> createState() {
    return _ClubDetail();
  }
}

final TextEditingController nameController = TextEditingController();

class _ClubDetail extends State<ClubDetail> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Details of Club: ${widget.exactClub.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${widget.exactClub.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Name: ${widget.exactClub.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Content: ${widget.exactClub.content}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Communication: ${widget.exactClub.communication}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Activities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.exactClub.activities.length,
                itemBuilder: (context, index) {
                  Activity activity = widget.exactClub.activities[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Activity ID: ${activity.id}'),
                          Text('Name: ${activity.name}'),
                          Text('Place: ${activity.place}'),
                          // Display Place
                          Text('Date: ${activity.date}'),
                          // Display Date
                          Text('Content: ${activity.content}'),
                          // Display Content
                          Text('Club ID: ${activity.clubid.toString()}'),
                          // Display Club ID
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                    builder: (context) => FilteredClubPage(
                          title: "Book Application",
                        )),
              );
            }
            if (_currentIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClubPage(
                          title: "Book Application",
                        )),
              );
            }
            if (_currentIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClubPageOfAdd(
                          title: "Book Application",
                        )),
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_1_outlined),
            label: 'Filtered Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'All Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Join a club',
          ),
        ],
      ),
    );
  }
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
      home: const ClubPage(title: 'Book Application'),
    );
  }
}

class ClubPage extends StatefulWidget {
  const ClubPage({super.key, required this.title});

  final String title;

  @override
  State<ClubPage> createState() => _MyHomePageState();
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

class _MyHomePageState extends State<ClubPage> {
  List<Club> allClubs = [];
  List<Activity> allActivities = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    fetchClubs();
    fetchActivities();
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

  Future<void> _loadUserId() async {
    String? userId = await getUserId();
    print(userId);
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
                    'Clubs',
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
                    itemCount: allClubs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final club = allClubs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 10.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClubDetail(
                                  exactClub: club,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                club.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
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
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityDetail(
                                  name: activity.name,
                                  id: activity.id,
                                  content: activity.content,
                                  place: activity.place,
                                  date: activity.date,
                                  clubId: activity.clubid.toString(),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                activity.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
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
              title: Text('Main Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDashboard(
                      title: "Book Application",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.filter_1_outlined),
              title: Text('Filtered Clubs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilteredClubPage(
                      title: "Book Application",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('All Clubs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClubPageOfAdd(
                      title: "Book Application",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Request for adding club to our university'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddClub(
                      title: "Club Page Of Add",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Request for adding activity to your club'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddActivity(
                      title: "Club Page Of Add",
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
                    builder: (context) => ActivityDashboard(
                      title: "Book Application",
                    )),
              );
            }
            if (_currentIndex == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilteredClubPage(
                      title: "Book Application",
                    )),
              );
            }
            if (_currentIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClubPageOfAdd(
                      title: "Book Application",
                    )),
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_1_outlined),
            label: 'Filtered Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'All Clubs',
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

  const Club(
      {required this.id,
      required this.name,
      required this.content,
      required this.communication,
      required this.usersId,
      required this.activities});
}