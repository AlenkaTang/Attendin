import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  var coursesWithLocationCollection =
      FirebaseFirestore.instance.collection('coursesWithLocation');
  Position? _currentPosition;
  double userLongtitude = 0.0;
  double userLatitude = 0.0;
  DateTime? currentTime;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCurrentTime() async {
    setState(() => currentTime = DateTime.now());
  }

  Future<void> ff() async {
    List<dynamic> c = [];
    var querySnapshot = await coursesWithLocationCollection.get();
    for (var data in querySnapshot.docs) {
      if (userLatitude == data['latitude'] &&
          userLongtitude == data['longtitude']) {
        c.add(data);
      }
    }
  }

  Future<void> userlocation() async {
    var userCureentLocation =
        FirebaseFirestore.instance.collection('userCurrentLocation');
    userCureentLocation.add({
      'longtitude': userLongtitude,
      'latitude': userLongtitude,
      'time': currentTime
    });
  }

  Future<void> userTime() async {
    var userCureentTime =
        FirebaseFirestore.instance.collection('userCurrentTime');
    userCureentTime.add({'Time': currentTime});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: $userLatitude'),
              Text('LNG: $userLongtitude'),
              Text('Time: $currentTime'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  _getCurrentPosition;
                  userTime();
                },
                child: const Text("Get Current Location"),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _getCurrentTime,
                child: const Text("Get Current Time"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
