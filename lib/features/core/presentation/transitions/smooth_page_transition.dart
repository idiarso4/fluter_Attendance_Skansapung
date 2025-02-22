import 'package:flutter/material.dart';

class SmoothPageTransition extends PageRouteBuilder {
  final Widget page;

  SmoothPageTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}

class SmoothNavigator {
  static Route createRoute(Widget page) {
    return SmoothPageTransition(page: page);
  }

  static void navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, createRoute(page));
  }

  static void replaceTo(BuildContext context, Widget page) {
    Navigator.pushReplacement(context, createRoute(page));
  }
}