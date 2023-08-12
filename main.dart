import 'package:attendin/firebase_courseInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'user_location.dart';
import 'firebase_courseInfo.dart';
import 'location_matching.dart';
import 'user_location_matching.dart';
//import 'courseDropdown.dart';
//import 'package:firebase_storage/firebase_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'AttendIn',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/query': (context) => const QueryScreen(),
        '/location': (context) => const LocationPage(),
        '/csc1301': (context) => const CSC1301(),
        '/csc1302': (context) => const CSC1302(),
        '/csc2510': (context) => const CSC2510(),
        '/notyetfinished': (context) => const NotyetFinished(),
        '/courseDisplay': (context) => CourseWithLocation(),
        //'/display': (context) => DropdownCourseList(),
        '/matchedcourseDisplay': (context) => UserLocationMatch(),
        '/testDropdown': (context) => const DropdownCRN(),
        //'CSC4352', 'CSC4360', 'CSC4370', 'CSC4520', 'CSC4710', 'CSC4720', 'CSC4740', 'CSC4760', 'CSC4780', 'CSC4810', 'CSC4841', 'CSC4850', 'CSC4851'
      },
    ),
  );
  //final storage = FirebaseStorage.instance;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () async {
                uploadCourses;
                upLoadLocation;
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/location');
            },
            child: const Text('Attendance Submission'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/testDropdown');
            },
            child: const Text('test Attendance Query'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/courseDisplay');
            },
            child: const Text('course display'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/matchedcourseDisplay');
            },
            child: const Text('matched courses '),
          ),
        ],
      )),
    );
  }
}

class QueryScreen extends StatelessWidget {
  const QueryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Query'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DropdownCRN(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      )),
    );
  }
}

const List<String> list = <String>[
  'Course Number',
  'CSC1301',
  'CSC1302',
  'CSC2510',
];

class DropdownCRN extends StatefulWidget {
  const DropdownCRN({super.key});
  @override
  State<DropdownCRN> createState() => _DropdownCRNState();
}

class _DropdownCRNState extends State<DropdownCRN> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        if (newValue != dropdownValue) {
          switch (newValue) {
            case 'CSC1301':
              Navigator.pushNamed(context, '/csc1301');
              break;
            case 'CSC1302':
              Navigator.pushNamed(context, '/csc1302');
              break;
            case 'CSC2510':
              Navigator.pushNamed(context, '/csc2510');
              break;

            default:
              Navigator.pushNamed(context, '/notyetfinished');
              break;
          }
        }
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class CSC1301 extends StatelessWidget {
  const CSC1301({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSC1301'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      )),
    );
  }
}

class CSC1302 extends StatelessWidget {
  const CSC1302({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSC1302'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      )),
    );
  }
}

class CSC2510 extends StatelessWidget {
  const CSC2510({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSC2510'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      )),
    );
  }
}

class NotyetFinished extends StatelessWidget {
  const NotyetFinished({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not yet Finished'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      )),
    );
  }
}
