import 'dart:async';
import 'package:flutter/material.dart';
import 'carousel_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _rotationAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.7, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _pulseAnim = Tween<double>(begin: 3.9, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _fadeAnim = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _rotationAnim = Tween<double>(begin: -9.2, end: 9.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
    Timer(const Duration(seconds: 5), () {
      _controller.dispose();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CarouselScreen()),
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 51, 43, 43),
                  const Color.fromARGB(255, 0, 0, 0),
                  const Color.fromARGB(255, 62, 66, 58),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: _fadeAnim.value,
                child: Transform.rotate(
                  angle: _rotationAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value * _pulseAnim.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // halo
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // ignore: deprecated_member_use
                                gradient: RadialGradient(colors: [Colors.white.withOpacity(0.12), Colors.transparent]),
                              ),
                            ),
                            // colored circle with icon
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
                                ],
                              ),
                              child: const Icon(Icons.quiz, size: 48, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return const Text(
                              'MBOAQUIZZ',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                                shadows: [Shadow(blurRadius: 12, color: Colors.black45, offset: Offset(2, 2))],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        const Text('Joue, apprends et découvre !', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
