import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding1.dart';


class LogoScreen extends StatefulWidget {
const LogoScreen({super.key});


@override
State<LogoScreen> createState() => _LogoScreenState();
}


class _LogoScreenState extends State<LogoScreen> with SingleTickerProviderStateMixin {
late AnimationController _controller;
late Animation<double> _scaleAnim;


@override
void initState() {
super.initState();
_controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
_scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
_controller.forward();


Timer(const Duration(seconds: 2), () {
Navigator.of(context).pushReplacement(
PageRouteBuilder(
transitionDuration: const Duration(milliseconds: 700),
pageBuilder: (context, a, b) => const OnboardScreen1(),
transitionsBuilder: (context, a, b, child) {
return FadeTransition(opacity: a, child: child);
},
),
);
});
}


@override
void dispose() {
_controller.dispose();
super.dispose();
}


@override
Widget build(BuildContext context) {
return Scaffold(
body: Stack(
fit: StackFit.expand,
children: [
// Background gradient
Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xFF651FFF), Color(0xFF00BFA5)],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
),
// Centered logo with scale animation
Center(
child: ScaleTransition(
scale: _scaleAnim,
child: Hero(
tag: 'eventra-logo',
child: Container(
padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.9),
borderRadius: BorderRadius.circular(16),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.18),
blurRadius: 20,
offset: const Offset(0, 8),
)
],
),
child: const Text(
'EVENTRA',
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.w800,
letterSpacing: 1.6,
color: Color(0xFF651FFF),
),
),
),
),
),
),
],
),
);
}
}