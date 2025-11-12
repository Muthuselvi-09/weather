import 'package:flutter/material.dart';
import 'screens/logo_screen.dart';
import 'screens/onboarding1.dart';
import 'screens/onboarding2.dart';

import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import '../widgets/animated_gradient_bg.dart';


void main() => runApp(const EventraApp());


class EventraApp extends StatelessWidget {
const EventraApp({super.key});


@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Eventra',
debugShowCheckedModeBanner: false,
theme: ThemeData(
useMaterial3: true,
colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
visualDensity: VisualDensity.adaptivePlatformDensity,
),
// initialRoute: '/',
// routes can be added here if you prefer named routing
home: const LogoScreen(),
);
}
}