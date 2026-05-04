import 'package:flutter/material.dart';
import 'location_access.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/assets/images/logo.png',
                        height: 32,
                        errorBuilder: (_, _, _) => const Icon(Icons.car_rental),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SAWARI',
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          letterSpacing: 1.5,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationAccessScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Cards List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildFeatureCard(
                      title: 'Book a Ride\nInstantly',
                      subtitle: 'Instantly connect with\nnearby drivers.',
                      graphic: _buildCarsGraphic(),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      title: 'Choose Your\nPrice',
                      subtitle: 'Submit and verify price\noffers with drivers.',
                      graphic: _buildPriceGraphic(),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      title: 'Safe & Live\nTracking',
                      subtitle: 'Real-time vehicle location\nand route sharing for\npeace of mind.',
                      graphic: _buildMapGraphic(),
                    ),
                  ],
                ),
              ),

              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(false),
                  const SizedBox(width: 8),
                  _buildDot(true), // active dot
                  const SizedBox(width: 8),
                  _buildDot(false),
                ],
              ),
              const SizedBox(height: 24),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationAccessScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3673), // Dark blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF1A3673) : const Color(0xFFCBD5E1),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required Widget graphic,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background watermark logo
          Positioned(
            right: -10,
            top: -10,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'lib/assets/images/logo.png',
                width: 70,
                height: 70,
              ),
            ),
          ),
          // Content
          Row(
            children: [
              // Graphic
              SizedBox(
                width: 130,
                height: 130,
                child: graphic,
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF475569),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarsGraphic() {
    return Image.asset(
      'lib/assets/images/cars.png',
      fit: BoxFit.contain,
    );
  }

  Widget _buildPriceGraphic() {
    return Image.asset(
      'lib/assets/images/calculation.png',
      fit: BoxFit.contain,
    );
  }

  Widget _buildMapGraphic() {
    return Image.asset(
      'lib/assets/images/location.png',
      fit: BoxFit.contain,
    );
  }
}
