import 'package:flutter/material.dart';
import '../authorization/login.dart';
class LoadingScreen extends StatefulWidget {
const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;
  AnimationController? _slideAnimationController;
  AnimationController? _textAnimationController;
  Animation<double>? _rotateAnimation;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(_animationController!);
    _animationController!.repeat(reverse: true);

    _slideAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _slideAnimation = Tween<Offset>(begin: const Offset(-2, 0), end: const Offset(0, 0)).animate(_slideAnimationController!);
    _slideAnimationController!.forward();

    _textAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(_textAnimationController!);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(parent: _textAnimationController!, curve: Curves.elasticOut));
    _textAnimationController!.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 5)).then((_) {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _slideAnimationController?.dispose();
    _textAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 65, 65, 65),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FadeTransition(
              opacity: _opacityAnimation!,
              child: Image.asset('images/vista_logo.png', width: 200),
            ),
            SlideTransition(
              position: _slideAnimation!,
              child: Transform.scale(
                scale: _scaleAnimation!.value,
                child: Transform.rotate(
                  angle: _rotateAnimation!.value,
                  child: Text(
                    'Vista',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
