import 'package:attendin/firebase_courseInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'user_location.dart';
import 'firebase_courseInfo.dart';

// ignore: must_be_immutable
class CourseWithLocation extends StatelessWidget {
  CourseWithLocation({super.key});

  var coursesCollection = FirebaseFirestore.instance.collection('courses');
  var locationCollection = FirebaseFirestore.instance.collection('location');
  var coursesWithLocationCollection =
      FirebaseFirestore.instance.collection('coursesWithLocation');
  Future<void> ff() async {
    var coursesQuerySnapshot = await coursesCollection.get();
    for (final courseDoc in coursesQuerySnapshot.docs) {
      final courseData = courseDoc.data();
      final building = courseData['building'];
      final locationQuerySnapshot = await locationCollection
          .where('buildingName', isEqualTo: building)
          .get();
      final locationData = locationQuerySnapshot.docs.first.data();
      final courseWithLocation = {
        'crn': courseData['crn'],
        'building': building,
        'courseNumber': courseData['courseNumber'],
        'meetingDay1': courseData['meetingDay1'],
        'meetingDay2': courseData['meetingDay2'],
        'meetingTime': courseData['meetingTime'],
        'latitude': locationData['buildingLAT'],
        'longitude': locationData['buildingLNG'],
      };
      await coursesWithLocationCollection
          .doc(courseData['crn'])
          .set(courseWithLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courses',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('courselist'),
          actions: [
            IconButton(
                onPressed: () async {
                  ff();
                },
                icon: const Icon(Icons.person))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: coursesWithLocationCollection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            final docs = snapshot.data?.docs;
            if (docs == null || docs.isEmpty) {
              return const Text('No courses found.');
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['courseNumber']),
                  subtitle: Text(
                    data['latitude'],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
