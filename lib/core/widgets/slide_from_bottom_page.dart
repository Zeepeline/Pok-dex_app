import 'package:flutter/material.dart';

class SlideFromBottomPage extends Page {
  final Widget child;

  const SlideFromBottomPage({required this.child, super.key});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Curve animasi yang lebih halus dan elegan
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutQuad, // Lebih halus dari easeOutCubic
        );

        // Slide dari bawah ke atas
        final slide = Tween<Offset>(
          begin:
              const Offset(0, 0.1), // Jangan mulai dari 1 penuh (terasa kasar)
          end: Offset.zero,
        ).animate(curved);

        // Fade-in
        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curved);

        // Sedikit scale untuk efek depth
        final scale = Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).animate(curved);

        return SlideTransition(
          position: slide,
          child: FadeTransition(
            opacity: fade,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
