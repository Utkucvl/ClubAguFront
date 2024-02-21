import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/addActivity.dart';
import 'package:loginpage/addClub.dart';
import 'package:loginpage/clubs.dart';
import 'package:loginpage/dashboard.dart';
import 'package:loginpage/joinclub.dart';
import 'package:loginpage/main.dart';
import 'package:loginpage/loginpage.dart';

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
Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF940404),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            ' $value',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    ),
  );
}




class _ClubDetail extends State<FilteredClubDetail> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBE9E7),
      appBar: AppBar(
        backgroundColor: Color(0xFF940404),
        title: Text(
          "Details of Club",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.exactClub.photoUrl),
            SizedBox(height: 15),
            Center(
              child: Text(
                ' ${widget.exactClub.name}',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Content: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.exactClub.content}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Communication:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.exactClub.communication}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Activities:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.exactClub.activities.length,
                itemBuilder: (context, index) {
                  Activity activity = widget.exactClub.activities[index];
                  return Card(
                    color: Color(0xFFFBE9E7),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${activity.name}'),
                          Text('Place: ${activity.place}'),
                          // Display Place
                          Text('Date: ${activity.date}'),
                          // Display Date
                          Text('Content: ${activity.content}'),
                          // Display Content

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFBE9E7)),
        useMaterial3: true,
      ),
      home: const FilteredClubPage(title: 'My Clubs'),
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

  Future<void> _removeClub(int userId, int clubId, String clubname) async {
    // API endpoint for login
    const String apiUrl = 'http://10.0.2.2:8080/club/remove';
    String? accessToken = await getAccessToken();

    try {
      // Show confirmation dialog
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Leave Club Confirmation'),
            content: Text(
              'Are you sure you want to leave the club called $clubname?',
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
        // User confirmed, proceed with removing the club
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

          // Check the response status code
          if (response.statusCode == 204) {
            setState(() {
              fetchClubs();
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
                        'You left the club called $clubname.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }
          // Check the response status code
          else {
            print('Request failed with status: ${response.statusCode}');
          }
        }
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

  Club? getClubById(int clubId) {
    // Search for the club by club ID
    Club? requiredClub;
    for (var club in allClubs) {
      if (int.parse(club.id) == clubId) {
        requiredClub = club;
        break;
      }
    }
    return requiredClub;
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
            backgroundColor: Color(0xFFFBE9E7),
            appBar: AppBar(
              backgroundColor: Color(0xFF940404),
              title: Text(
                "MY CLUBS",
                style: TextStyle(color: Colors.white),
              ),
            ),
            drawer: Drawer(
              child: Container(
                color: Color(0xFFFBE9E7),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 200,
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
                        Icons.home,
                        color: Color(0xFF940404),
                      ),
                      title: Text(
                        'Main Dashboard',
                        style: TextStyle(
                            color: Color(0xFF940404),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
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
                      leading: Icon(
                        Icons.bookmark,
                        color: Color(0xFF940404),
                      ),
                      title: Text(
                        'My Clubs',
                        style: TextStyle(
                            color: Color(0xFF940404),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
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
                            builder: (context) => ClubPageOfAdd(
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
                        'Request for adding club',
                        style: TextStyle(
                            color: Color(0xFF940404),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
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
                      leading: Icon(
                        Icons.add_box_outlined,
                        color: Color(0xFF940404),
                      ),
                      title: Text(
                        'Request for adding activity',
                        style: TextStyle(
                            color: Color(0xFF940404),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
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
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xFF940404),
                      ),
                      // Icon for logout
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
            body: SingleChildScrollView(
              child: Column(
                children: filteredClubs.map((club) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilteredClubDetail(exactClub: club),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        club.photoUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 35),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            club.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () async {
                                      String? userIdString = await getUserId();
                                      if (userIdString != null) {
                                        int userId = int.tryParse(userIdString) ?? 0;
                                        int clubId = int.tryParse(club.id) ?? 0;
                                        _removeClub(userId, clubId, club.name);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Activities Section for the Club
                      // Activities Section for the Club
                      ...club.activities.map((activity) {
                        return InkWell(
                          onTap: () {
                            _showDetailOfActivity(context, activity);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Container(
                              height: 80,
                              width: double.infinity,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          getClubById(activity.clubid)!.photoUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activity.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            activity.date,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                    ],
                  );
                }).toList(),
              ),
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
