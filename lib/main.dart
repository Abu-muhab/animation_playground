import 'package:animations/pages/flying_expanding_card_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        "/flying_expanding_card": (context) =>
            FlyingExpandingCardAnimationPage()
      },
      initialRoute: "/flying_expanding_card",
    );
  }
}
