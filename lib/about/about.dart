import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vista_app/authorization/login.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _locationEnabled = false;
  String _location = "Not Set";
  bool _savingProfile = false;
  bool _notificationsEnabled = true;
  String _email = "";
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locationEnabled = prefs.getBool('locationEnabled') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _email = prefs.getString('email') ?? "";
      _darkModeEnabled = prefs.getBool('darkModeEnabled') ?? false;
    });
    if (_locationEnabled) {
      _getCurrentLocation();
    }
    // Retrieve email from Firestore
    _retrieveEmailFromFirestore();
  }

  Future<void> _retrieveEmailFromFirestore() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc('your_document_id').get();
      if (userDoc.exists) {
        setState(() {
          _email = userDoc['email'];
        });
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error retrieving email: $e');
    }
  }

  Future<void> _updateLocationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('locationEnabled', value);
    setState(() {
      _locationEnabled = value;
      if (value) _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    if (_locationEnabled && await Geolocator.isLocationServiceEnabled()) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = "${position.latitude}, ${position.longitude}";
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _savingProfile = true;
    });
    // Simulate saving profile data
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _savingProfile = false;
    });
    // Show a success message or navigate back
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // After logging out, clear any stored preferences or navigate to the login screen
      final prefs = await SharedPreferences.getInstance();
      prefs.clear(); // Clear all stored preferences
      // Navigate to the login screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      print('Error logging out: $e');
    }
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
              'Vista Profile',
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
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Display Location Services'),
            subtitle: Text('Toggle to enable or disable to display current location for services.'),
            trailing: Switch(
              value: _locationEnabled,
              onChanged: _updateLocationPreference,
              activeColor: Colors.purple,
            ),
          ),
          if (_locationEnabled) // Show current location only if enabled
            ListTile(
              leading: Icon(Icons.location_searching),
              title: Text('Current Location'),
              subtitle: Text(_location),
            ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(' Are you enjoying this app because me too!'),
            subtitle: Text('Toggle back in forth so you have something else to do in the hub!'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('notificationsEnabled', value);
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
            subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? 'No email set'),
            onTap: () {
              // Navigate to edit email screen
            },
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          ),

        ],
      ),
    );
  }
}
