import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import './about/about.dart';
import './loading/loading.dart';
import './search/search.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vista: Social Media Hub',
      theme: ThemeData.dark(),
      home: const LoadingScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/about': (context) => ProfileSettingsScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isPosting = false;
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

    Position position = await Geolocator.getCurrentPosition();
    print('Current Position: ${position.latitude}, ${position.longitude}');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.pushNamed(context, '/about');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/search');
    }
  }

  void _togglePostBar() {
    setState(() {
      _isPosting = !_isPosting;
    });
  }

  void _submitData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String locationString = '${position.latitude}, ${position.longitude}';

    FirebaseFirestore.instance.collection('people').add({
      'first': FirebaseAuth.instance.currentUser?.email ?? '',
      'last': '',
      'post': _postController.text,
      'location': locationString,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post has been created successfully!'),
          duration: Duration(seconds: 2),
        )
      );
      _postController.clear();
      _togglePostBar();
    }).catchError((error) {
      print("Error adding document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'images/vista_logo.png',
              height: 24.0,
            ),
            const SizedBox(width: 8),
            Text(
              'Vista',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          if (_isPosting)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _postController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'What’s new? Let\'s add it',
                  prefixIcon: Icon(Icons.edit),
                ),
              ),
            ),
          if (_isPosting)
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Submit'),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('people').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 16.0),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 3.0,
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                            '${data['first']} ${data['last']}',
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          subtitle: Text(
                            'Recent Post: ${data['post']} - Location: ${data['location']}',
                            style: const TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePostBar,
        tooltip: 'Post',
        child: Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
