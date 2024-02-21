import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginpage/addActivity.dart';
import 'package:loginpage/addClub.dart';
import 'package:loginpage/clubs.dart';
import 'package:loginpage/dashboard.dart';
import 'package:loginpage/filteredclubs.dart';
import 'package:loginpage/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class ClubDetailOfAdd extends StatefulWidget {
  const ClubDetailOfAdd({
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

class _ClubDetail extends State<ClubDetailOfAdd> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C),
        title: Text(
          "DETAILS OF CLUB",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color:
              Color(0xFFFBE9E7), // Arka plan rengini burada belirleyebilirsiniz
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // Başlangıçta hizala
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(widget.exactClub.photoUrl,
                      width: 60, height: 60),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' ${widget.exactClub.name}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                'CONTENT: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                '${widget.exactClub.content}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'COMMUNICATION:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                ' ${widget.exactClub.communication}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'ACTIVITIES:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

class ClubPageOfAdd extends StatefulWidget {
  const ClubPageOfAdd({super.key, required this.title});

  final String title;

  @override
  State<ClubPageOfAdd> createState() => _MyHomePageState();
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

class _MyHomePageState extends State<ClubPageOfAdd> {
  List<Club> allClubs = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    fetchClubs();
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

  Future<void> _addClub(int userId, int clubId, String clubname) async {
    // API endpoint for login
    const String apiUrl = 'http://10.0.2.2:8080/club/add';
    String? accessToken = await getAccessToken();

    // Show a confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Join Club Confirmation'),
          content: Text('Do you want to join the club called $clubname?', style: TextStyle(fontSize: 15),),
          actions: <Widget>[
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

    // Proceed only if the user confirmed
    if (confirm == true) {
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
                      'You joined the club called $clubname',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FilteredClubPage(title: "Home Page")),
            );
          }
        } else {
          // Check the response status code
          print('Request failed with status:');
        }
      } catch (e) {
        // Handle any errors that might occur
        print('Error: $e');
      }
    } else {
      // User canceled, you can add any additional handling here
      print('User canceled the operation');
    }
  }

  Future<void> _loadUserId() async {
    String? userId = await getUserId();
    print(userId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBE9E7),
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C),
        title: Text(
          "ALL CLUBS",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
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
                ),
                Expanded(
                  child: ListView.builder(
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
                                builder: (context) => ClubDetailOfAdd(
                                  exactClub: club,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            shadowColor: Color(0xFF940404),
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image.network(
                                  club.photoUrl,
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  club.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  String? userIdString = await getUserId();
                                  if (userIdString != null) {
                                    int userId =
                                        int.tryParse(userIdString) ?? 0;
                                    int clubId = int.tryParse(club.id) ?? 0;
                                    // Use userId here or perform any other actions
                                    _addClub(userId, clubId, club.name);
                                  }
                                },
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
