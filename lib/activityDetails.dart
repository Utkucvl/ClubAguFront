import 'package:flutter/material.dart';
import 'package:loginpage/clubs.dart';

import 'package:loginpage/filteredclubs.dart';
import 'package:loginpage/joinclub.dart';

class ActivityDetail extends StatefulWidget {
  const ActivityDetail({
    super.key,
    required this.name,
    required this.id,
    required this.content,
    required this.place,
    required this.date,
    required this.clubId,
  });

  final String name;
  final String id;
  final String content;
  final String place;
  final String date;
  final String clubId;

  @override
  State<StatefulWidget> createState() {
    return _ActivityDetail();
  }
}

final TextEditingController nameController = TextEditingController();

class _ActivityDetail extends State<ActivityDetail> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Details of Activity with Id: ${widget.id}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID : ${widget.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Name : ${widget.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Content : ${widget.content}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Place : ${widget.place}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Date : ${widget.date}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Id of Club : ${widget.clubId}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),

    );
  }
}


