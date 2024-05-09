import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import './signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  String? error;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // Use dark theme
      home: Scaffold(
        backgroundColor: Colors.grey[900], // Change background color to dark
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/vista_logo.png', width: 150),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Log in below to access your account.",
                    style: TextStyle(
                      color: Colors.white, // Change text color to white
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.white), // Change hint text color to white
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey[800], // Change input field background color to dark
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  maxLength: 64,
                  onChanged: (value) => email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    hintText: "Enter a password",
                    hintStyle: TextStyle(color: Colors.white), // Change hint text color to white
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey[800], // Change input field background color to dark
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  obscureText: true,
                  onChanged: (value) => password = value,
                  validator: (value) {
                    if (value == null || value.length < 5) {
                      return 'Your password must contain at least 5 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Change button color to red
                    elevation: 3, // Add elevation to button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Round the button edges
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Increase button padding
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      tryLogin();
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white, // Change text color to white
                    ),
                  ),
                ),
                if (error != null)
                  Text(
                    "Error: $error",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void tryLogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
      print("Logged in ${credential.user}");
      error = null;
      setState(() {});

      if (!mounted) return;

      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else {
        error = 'An error occurred: ${e.message}';
      }

      setState(() {});
    }
  }
}
