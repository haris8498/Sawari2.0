import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  bool _imagesPrecached = false;

  @override
  void initState() {
    super.initState();

    // Set system UI to match the deep blue bottom of the splash screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF0B2154), // Matched to bottom gradient
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)); // Smoother fade curve

    _startApp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Prevent precache from running multiple times if dependencies change
    if (!_imagesPrecached) {
      _precacheAssets();
      _imagesPrecached = true;
    }
  }

  void _precacheAssets() {
    precacheImage(const AssetImage('lib/assets/images/logo.png'), context);
    precacheImage(const AssetImage('lib/assets/images/map.png'), context);
    precacheImage(const AssetImage('lib/assets/images/dark.png'), context);
    precacheImage(const AssetImage('lib/assets/images/passenger.png'), context);
    precacheImage(const AssetImage('lib/assets/images/car.png'), context);
    precacheImage(const AssetImage('lib/assets/images/share.png'), context);
    precacheImage(const AssetImage('lib/assets/images/percel.png'), context);
  }

  void _startApp() async {
    // Wait for the 2-second fade-in animation to complete
    try {
      await _ctrl.forward().orCancel;
      // Keep the splash screen fully visible for exactly 1 more second (3s total)
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Reset System UI for the next screens if needed here, or let the next screen handle it
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on TickerCanceled {
      // The animation got canceled (e.g., user exited the app), do nothing
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF), // White at top
                  Color(0xFFB0CDE6), // Light blue
                  Color(0xFF3868A8), // Mid blue
                  Color(0xFF0B2154), // Deep blue at bottom
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Wavy Lines Background
          Positioned.fill(child: CustomPaint(painter: WavesPainter())),

          // Main Content
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Logo
                Center(
                  child: Image.asset(
                    'lib/assets/images/logo.png',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_taxi_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFE082), Color(0xFFD4AF37)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: const Text(
                    'SAWARI',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 8.0,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Subtitle
                const Text(
                  'Your Ride, Your Price',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE8C678), // Softer Gold color for better readability
                    letterSpacing: 1.5,
                  ),
                ),

                const Spacer(flex: 2),

                // Bottom Knob/Lock Element
                const BottomKnob(),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..isAntiAlias = true; // Ensures smooth, non-pixelated curves

    for (int i = 0; i < 30; i++) {
      final path = Path();

      double startY = size.height * 0.45 + (i * 10);
      path.moveTo(0, startY);

      double cp1X = size.width * 0.4 + (i * 6);
      double cp1Y = size.height * 0.4 - (i * 22);

      double cp2X = size.width * 0.7 - (i * 3);
      double cp2Y = size.height * 0.2 + (i * 18);

      double endX = size.width;
      double endY = size.height * 0.1 + (i * 20);

      path.cubicTo(cp1X, cp1Y, cp2X, cp2Y, endX, endY);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BottomKnob extends StatelessWidget {
  const BottomKnob({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Rotating Dial (Silver Ring + Inner Circles + Bolts)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 4),
            curve: Curves.easeOutQuart, // Decelerating smooth curve
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * pi, // Full 360 degree rotation
                child: child,
              );
            },
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Silver Ring
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF5F5F5),
                          Color(0xFFE0E0E0),
                          Color(0xFF9E9E9E),
                          Color(0xFFE0E0E0),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 0.3, 0.7, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Softened shadow
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // Inner Gold Ring
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFF1C5),
                              Color(0xFFD4AF37),
                              Color(0xFF996515),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          // Inner Blue Circle with marble cracks
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [Color(0xFF2A5CAA), Color(0xFF091636)],
                                center: Alignment(-0.3, -0.3),
                                radius: 0.9,
                              ),
                            ),
                            child: CustomPaint(painter: MarblePainter()),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Little bolts on the silver ring
                  ..._buildBolts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBolts() {
    List<Widget> bolts = [];
    double radius = 61; // Adjusted slightly for optical center
    for (int i = 0; i < 4; i++) {
      double angle = i * pi / 2 + pi / 4;
      bolts.add(
        Positioned(
          left: 70 - 4 + radius * cos(angle),
          bottom: 70 - 4 + radius * sin(angle),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFBDBDBD),
              gradient: const LinearGradient(
                colors: [Color(0xFFEEEEEE), Color(0xFF9E9E9E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 2,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return bolts;
  }
}

class MarblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.25, size.height * 0.2);
    path.lineTo(size.width * 0.15, size.height * 0.4);
    path.lineTo(size.width * 0.35, size.height * 0.7);
    path.lineTo(size.width * 0.3, size.height);

    path.moveTo(size.width * 0.8, 0);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width * 0.85, size.height * 0.5);
    path.lineTo(size.width * 0.65, size.height * 0.8);
    path.lineTo(size.width * 0.7, size.height);

    path.moveTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.55);
    path.lineTo(size.width * 0.6, size.height * 0.35);
    path.lineTo(size.width, size.height * 0.45);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}