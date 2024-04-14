import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  
import 'package:firebase_auth/firebase_auth.dart';
import 'customdata.dart'; 
import './about/about.dart';
import './loading/loading.dart';
import './authorization/login.dart';
// import './search/search.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vista: Social Media Hub',
      home: const LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'images/vista_logo.png',
              height: 20.0,
            ),
            const SizedBox(width: 8),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.grey),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostListScreen()));
            },
            child: const Text(
              'History',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome ${FirebaseAuth.instance.currentUser?.email}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
              },
              child: const Text("Go to About Screen"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}


class PostListScreen extends StatelessWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Posts")),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)));
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage(post.imageUrl),
                radius: 24,
              ),
              title: Text(post.content),
              subtitle: Text("Posted by ${post.author} - ${post.timestamp}"),
            ),
          );
        },
      ),
    );
  }
}

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const contentTextStyle = TextStyle(fontSize: 20);
    return Scaffold(
      appBar: AppBar(title: const Text("Post Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(post.imageUrl),
            const SizedBox(height: 8),
            Text(post.content, style: contentTextStyle),
            const SizedBox(height: 8),
            Text("Posted by ${post.author} - ${post.timestamp}"),
          ],
        ),
      ),
    );
  }
}


