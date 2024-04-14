import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? password;
  String? repeatPassword;
  String? error;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 65, 65, 65),
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
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Register your account here.",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 165, 165, 165),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                maxLength: 64,
                onChanged: (value) => email = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter an email' : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter a password",
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 165, 165, 165),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                obscureText: true,
                maxLength: 64,
                onChanged: (value) => password = value,
                validator: (value) => value == null || value.length < 5 ? 'Password must contain at least 5 characters' : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Repeat password',
                  border: OutlineInputBorder(),
                  fillColor: Color.fromARGB(255, 165, 165, 165),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                obscureText: true,
                maxLength: 64,
                onChanged: (value) => repeatPassword = value,
                validator: (value) => value != password ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Sign Up', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    trySignup();
                  }
                },
              ),
              if (error != null)
                Text(
                  "Error: $error",
                  style: TextStyle(color: Colors.red[800], fontSize: 12),
                ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Already have an account? Log in",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void trySignup() async {
    try {
      var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } catch (e) {
      setState(() {
        error = "Account successfully created! Please log in.";
      });
    }
  }
}
