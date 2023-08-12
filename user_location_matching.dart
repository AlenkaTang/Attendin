import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserLocationMatch extends StatelessWidget {
  UserLocationMatch({super.key});

  String? userLong;
  String? userLat;
  List matchedCourses = <String>[];

  var userCureentLocation =
      FirebaseFirestore.instance.collection('userCurrentLocation');
  var coursesMatchingLONG =
      FirebaseFirestore.instance.collection('coursesWithLONG');
  var coursesMatchingLAT =
      FirebaseFirestore.instance.collection('coursesWithLAT');
  var coursesWithLocationCollection =
      FirebaseFirestore.instance.collection('coursesWithLocation');

  Future<void> matchingLocationff() async {
    var userquery = await userCureentLocation.get();
    for (final userDoc in userquery.docs) {
      final userData = userDoc.data();
      userLong = userData['longtitude'];
      userLat = userData['latitude'];
    }
    var longQuery = await coursesWithLocationCollection.get();
    for (final longDoc in longQuery.docs) {
      final longData = longDoc.data();
      final courseLong = longData['longtitude'];
      if (courseLong == userLong) {
        coursesMatchingLONG.add({
          'longtitude': longData['longtitude'],
          'latitude': longData['latitude'],
          'crn': longData['crn'],
          'courseNumber': longData['courseNumber'],
          'building': longData['building']
        });
      }
    }
    var matchQuery = await coursesMatchingLONG.get();
    for (final matchDoc in matchQuery.docs) {
      final matchData = matchDoc.data();
      final matchLat = matchData['latitude'];
      if (matchLat == userLat) {
        coursesMatchingLAT.add({
          'crn': matchData['crn'],
          'courseNumber': matchData['courseNumber'],
          'building': matchData['building']
        });
      }
    }
  }

  Future<List> displayMatchedCourses() async {
    var courseQuery = await coursesMatchingLAT.get();
    for (final cDoc in courseQuery.docs) {
      final courseInfo = cDoc.data();
      final crn = courseInfo['courseNumber'];
      matchedCourses.add(crn);
    }
    return matchedCourses;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'matched courses ',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('courselist'),
            actions: [
              IconButton(
                  onPressed: () async {
                    matchingLocationff();
                  },
                  icon: const Icon(Icons.person))
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      matchingLocationff();
                    },
                    child: const Text('Update matched courses')),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/testDropdown');
                    },
                    child: const Text('display matched courses')),
              ],
            ),
          )),
    );
  }
}
