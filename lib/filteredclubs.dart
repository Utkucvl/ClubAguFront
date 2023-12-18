import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/activityDetails.dart';
import 'package:loginpage/addActivity.dart';
import 'package:loginpage/addClub.dart';
import 'package:loginpage/clubs.dart';
import 'package:loginpage/dashboard.dart';
import 'package:loginpage/joinclub.dart';
import 'package:loginpage/main.dart';

void main() {
  runApp(const MyApp());
}

class FilteredClubDetail extends StatefulWidget {
  const FilteredClubDetail({
    super.key,
    required this.exactClub,
  });

  final Club exactClub;

  @override
  State<StatefulWidget> createState() {
    return _ClubDetail();
  }
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



class _ClubDetail extends State<FilteredClubDetail> {
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
      home: const FilteredClubPage(title: 'Book Application'),
    );
  }
}

class FilteredClubPage extends StatefulWidget {
  const FilteredClubPage({super.key, required this.title});

  final String title;

  @override
  State<FilteredClubPage> createState() => _MyHomePageState();
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

class _MyHomePageState extends State<FilteredClubPage> {
  int _currentIndex = 0;
  List<Club> allClubs = [];
  List<Activity> allActivities = [];
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    fetchClubs();
    _fetchActivities();
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

  Future<void> _removeClub(int userId, int clubId) async {
    // API endpoint for login
    const String apiUrl = 'http://10.0.2.2:8080/club/remove';
    String? accessToken = await getAccessToken();
    try {
      // Create a Map to hold the request body data
      Map<String, int> data = {
        'userId': userId,
        'clubId': clubId,
      };

      // Encode the data to JSON
      String body = json.encode(data);

      // Make POST request
      if (accessToken != null) {
        http.Response response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': accessToken,
          },
          body: body,
        );
        if (response.statusCode == 204) {
          setState(() {
            fetchClubs();
          });
        }
      }
      // Check the response status code
      else {
        print('Request failed with status:');
      }
    } catch (e) {
      // Handle any errors that might occur
      print('Error: $e');
    }
  }

  Future<void> _fetchActivities() async {
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
    String? id = await getUserId();
    setState(() {
      userId = id ?? "Not available";
    });
  }

  List<Club> _filterClubs(String id) {
    return allClubs
        .where((element) => element.usersId.contains(int.parse(id)))
        .toList();
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
    return FutureBuilder<String?>(
      future: getUserId(), // Add the future parameter here
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          userId = snapshot.data ?? "Not available";
          List<Club> filteredClubs = _filterClubs(userId);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
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
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    children: filteredClubs.map((club) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30.0,
                          horizontal: 5.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilteredClubDetail(
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
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilteredClubDetail(
                                      exactClub: club,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            club.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () async {
                                        String? userIdString = await getUserId();
                                        if (userIdString != null) {
                                          int userId = int.tryParse(userIdString) ?? 0;
                                          int clubId = int.tryParse(club.id) ?? 0;
                                          _removeClub(userId, clubId);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    children: filteredClubs.isNotEmpty && filteredClubs.length > 0
                        ? filteredClubs.expand((club) => club.activities.map((activity) {
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: InkWell(
                          onTap: () {
                            _showDetailOfActivity(context, activity);
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.green,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                activity.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })).toList()
                        : [Container()],
                  ),
                ),
              ],
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
        } else {
          // Show loading or handle other states if needed
          return CircularProgressIndicator();
        }
      },
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
