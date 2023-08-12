import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadCourses() async {
  // Read the contents of the text file.
  final file = File('/Users/tangalenka/development/attendin/courseInfo.txt');
  final contents = await file.readAsLines();
  final collection = FirebaseFirestore.instance.collection('courses');
  // Parse the contents of the text file into individual course records.
  for (var course in contents) {
    final parts = course.split(',');
    collection.add({
      'crn': parts[0].trim(),
      'courseNumber': parts[1].trim(),
      'courseName': parts[3].trim(),
      'building': parts[4].trim(),
      'meetingDay1': parts[8].trim(),
      'meetingDay2': parts[9].trim(),
      'meetingTime': parts[10].trim()
    });
  }
}

Future<void> upLoadLocation() async {
  final file = File('/Users/tangalenka/development/attendin/lib/location.txt');
  final contents = await file.readAsLines();
  final collection = FirebaseFirestore.instance.collection('location');
  for (var building in contents) {
    final parts = building.split(',');
    collection.add({
      'buildingName': parts[0].trim(),
      'buildingLAT': parts[1].trim(),
      'buildingLNG': parts[2].trim()
    });
  }
}
