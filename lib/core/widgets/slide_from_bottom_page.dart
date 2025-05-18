import 'package:flutter/material.dart';

class SlideFromBottomPage extends Page {
  final Widget child;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  const SlideFromBottomPage({
    required this.child,
    super.key,
    this.transitionDuration = const Duration(milliseconds: 700),
    this.reverseTransitionDuration = const Duration(milliseconds: 500),
  });

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutQuad,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.1), // from bottom
          end: Offset.zero,
        ).animate(curvedAnimation);

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        final scaleAnimation = Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).animate(curvedAnimation);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
