import 'package:flutter/material.dart';
import 'otp_verification.dart';

class DriverSignUpScreen extends StatelessWidget {
  const DriverSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Sign Up', style: TextStyle(color: Color(0xFF0F265C), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F265C)),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9F0F8),
              Color(0xFFF4F7FB),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'lib/assets/images/driver.png',
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Apply to Drive',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F265C),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                const Text(
                  'Personal Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B5DA6)),
                ),
                const Divider(),
                const SizedBox(height: 10),
                
                _buildLabel('Full Name'),
                _buildTextField(hint: 'John Doe', icon: Icons.person_outline),
                const SizedBox(height: 16),
                
                _buildLabel('Phone Number'),
                _buildTextField(hint: '0300 1234567', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                
                _buildLabel('CNIC'),
                _buildTextField(hint: '12345-1234567-1', icon: Icons.badge_outlined, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                
                _buildLabel('Password'),
                _buildTextField(hint: '••••••••', icon: Icons.lock_outline, isPassword: true),
                const SizedBox(height: 30),

                const Text(
                  'Authorization & Vehicle Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B5DA6)),
                ),
                const Divider(),
                const SizedBox(height: 10),

                _buildLabel('Driving License Number'),
                _buildTextField(hint: 'DL-123456789', icon: Icons.credit_card_outlined),
                const SizedBox(height: 16),

                _buildLabel('Vehicle Make & Model'),
                _buildTextField(hint: 'Toyota Corolla 2020', icon: Icons.directions_car_outlined),
                const SizedBox(height: 16),

                _buildLabel('Vehicle Registration Number'),
                _buildTextField(hint: 'ABC-1234', icon: Icons.pin_outlined),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OtpVerificationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF133676).withValues(alpha: 0.4),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2B63B6), Color(0xFF113677)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Submit Application',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6B8DB8), size: 24),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB0C4DE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB0C4DE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0F265C), width: 2.0),
        ),
      ),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}
