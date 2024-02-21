body: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Expanded(
child: GridView(
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 1,
),
children: filteredClubs.map((club) {
return Padding(
padding: const EdgeInsets.only(
top: 50.0,
left: 10,
right: 10,
bottom: 10,
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
child: Row(
children: [
Padding(
padding: const EdgeInsets.all(8.0),
child: ClipRRect(
borderRadius: BorderRadius.circular(8.0),
child: Image.network(
club.photoUrl,
width: 50,
height: 50,
fit: BoxFit.cover,
),
),
),
Expanded(
child: Padding(
padding: const EdgeInsets.only(top: 35.0, left: 25),
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
_removeClub(userId, clubId, club.name);
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
padding: const EdgeInsets.only(
top: 50.0,
left: 10,
right: 10,
bottom: 50,
),
child: InkWell(
onTap: () {
_showDetailOfActivity(context, activity);
},
child: Card(
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10.0),
),
color: Colors.white70,
child: Row(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Padding(
padding: const EdgeInsets.all(8.0),
child: Image.network(
getClubById(activity.clubid)!.photoUrl,
width: 50,
height: 50,
fit: BoxFit.cover,
),
),
Column(
children: [
Padding(
padding: const EdgeInsets.only(
top: 25.0,
left: 25,
),
child: Text(
activity.name,
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 12,
),
),
),
Padding(
padding: const EdgeInsets.only(
top: 5.0,
left: 25,
),
child: Text(
activity.date,
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 12,
),
),
),
],
),
],
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



);