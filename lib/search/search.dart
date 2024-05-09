import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VistaPost {
  final String title;
  final String description;
  final String imageUrl;

  VistaPost({required this.title, required this.description, required this.imageUrl});
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  bool _isLoading = false;
  List<String> _searchResults = [];
  String? _welcomeMessage;
  StreamSubscription<Position>? _positionStream;
  Position? _currentPosition;

 List<VistaPost> vistaPosts = [
  VistaPost(
    title: "Play Games",
    description: "Experience the thrill of gaming anytime, anywhere.",
    imageUrl: "../images/game.jpeg",
  ),
  VistaPost(
    title: "Messaging App",
    description: "Stay connected with your loved ones no matter where you are.",
    imageUrl: "../images/message.jpeg",
  ),
  VistaPost(
    title: "News App",
    description: "Stay informed about the latest happenings around the world.",
    imageUrl: "../images/news.jpg",
  ),
  VistaPost(
    title: "Weather App",
    description: "Plan your day ahead with accurate weather forecasts.",
    imageUrl: "../images/weather.jpeg",
  ),
];


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _positionStream?.cancel();
    super.dispose();
  }

  void _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _welcomeMessage = 'Location services are disabled.');
      _showDialog('Location Disabled', 'Please enable location services to use this feature.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _welcomeMessage = 'Location permissions are denied');
        _showDialog('Location Permission', 'Location permission is needed to access your location. Please grant permission.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _welcomeMessage = 'Location permissions are permanently denied, we cannot request permissions.');
      _showDialog('Location Permission Denied', 'Location permissions are permanently denied. Please enable them in your device settings.');
      return;
    }

    _startPositionStreaming();
  }

  void _startPositionStreaming() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      )
    ).listen(
      (Position position) {
        setState(() {
          _currentPosition = position;
          String email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown User';
          _welcomeMessage = "Welcome $email from Lat:${position.latitude}, Long:${position.longitude}";
        });
      }
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _performSearch(String keywords) {
    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    FirebaseFirestore.instance
        .collection('people')
        .where('first', isGreaterThanOrEqualTo: keywords)
        .where('first', isLessThanOrEqualTo: keywords + '\uf8ff')
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isEmpty) {
            setState(() {
              _isLoading = false;
              _searchResults.add('No results found.');
            });
          } else {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String result = 'Email: ${data['first']}';
              if (data['last'] != '') {
                result += ', Last: ${data['last']}';
              }
              if (data['location'] != '') {
                result += ', Location: ${data['location']}';
              }
              if (data['post'] != '') {
                result += ', Post: ${data['post']}';
              }
              _searchResults.add(result); // Format the string as needed
            });
            setState(() {
              _isLoading = false;
            });
          }
        }).catchError((error) {
          setState(() {
            _isLoading = false;
            _searchResults.add('Search failed: $error');
          });
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
              'Vista Search',
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
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Title for Search Bar
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Search by First Name (sorted by proximity closest to you):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter First Name...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              filled: true,
              fillColor: Colors.grey[200],
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _performSearch(_searchController.text),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
            ? Center(child: CircularProgressIndicator())
            : SizedBox.shrink(),
          // Search Results
          ..._searchResults.map((result) => ListTile(
            title: Text(result),
            leading: Icon(Icons.post_add, color: Colors.white24),
          )).toList(),
          // New Text Element Here
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Scroll for more! Also here are some other features that are coming:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Images Grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: vistaPosts.length,
            itemBuilder: (context, index) {
              final post = vistaPosts[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: GridTile(
                  header: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black.withOpacity(0.7),
                    alignment: Alignment.center,
                    child: Text(
                      post.title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.asset(
                      post.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  footer: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black.withOpacity(0.7),
                    alignment: Alignment.center,
                    child: Text(
                      post.description,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

}
