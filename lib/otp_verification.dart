import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'driver_dashboard.dart';
import 'passenger_dashboard.dart';
import 'services/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final bool isDriver; // Added flag to determine the role
  final String? phoneNumber; // E.164 format, e.g. +923001234567

  const OtpVerificationScreen({super.key, this.isDriver = false, this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // 6-digit codes are standard for Firebase Phone Auth.
  static const int _otpLength = 6;
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  bool _assetsPrecached = false;
  String? _verificationId;
  bool _isSending = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _sendCode());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_assetsPrecached) {
      _precacheAssets();
      _assetsPrecached = true;
    }
  }

  Future<void> _sendCode() async {
    final phone = widget.phoneNumber;
    if (phone == null) return;
    setState(() => _isSending = true);
    try {
      await AuthService.instance.sendOtp(
        phone: phone,
        onCodeSent: (verificationId, _) {
          setState(() {
            _verificationId = verificationId;
            _isSending = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification code sent.')),
          );
        },
        onFailed: (e) {
          setState(() => _isSending = false);
          _showError(e.message ?? 'Failed to send code');
        },
        onAutoVerified: (cred) async {
          // Auto-retrieval on Android: complete sign-in.
          await _completeWithCredential(cred);
        },
      );
    } catch (e) {
      setState(() => _isSending = false);
      _showError(e.toString());
    }
  }

  Future<void> _completeWithCredential(PhoneAuthCredential cred) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await user.linkWithCredential(cred);
      } else {
        await FirebaseAuth.instance.signInWithCredential(cred);
      }
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked' ||
          e.code == 'credential-already-in-use') {
        _navigateToDashboard();
      } else {
        _showError(e.message ?? 'Verification failed');
      }
    }
  }

  void _navigateToDashboard() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => widget.isDriver
            ? const DriverDashboard()
            : const PassengerDashboard(),
      ),
      (_) => false,
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _precacheAssets() {
    precacheImage(const AssetImage('lib/assets/images/map.png'), context);
    precacheImage(const AssetImage('lib/assets/images/dark.png'), context);
    precacheImage(const AssetImage('lib/assets/images/passenger.png'), context);
    precacheImage(const AssetImage('lib/assets/images/car.png'), context);
    precacheImage(const AssetImage('lib/assets/images/share.png'), context);
    precacheImage(const AssetImage('lib/assets/images/percel.png'), context);
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final code = _controllers.map((c) => c.text).join();
    // If we have no phone number context, just proceed (the user is already
    // signed in via email/password).
    if (widget.phoneNumber == null) {
      _navigateToDashboard();
      return;
    }
    if (_verificationId == null) {
      _showError('Code not yet sent. Please wait or tap resend.');
      return;
    }
    if (code.length < _otpLength) {
      _showError('Enter the full $_otpLength-digit code');
      return;
    }
    setState(() => _isVerifying = true);
    try {
      await AuthService.instance.confirmOtp(
        verificationId: _verificationId!,
        smsCode: code,
      );
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Invalid code');
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Verification',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : theme.colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security_rounded,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'We have sent a 4-digit code to your registered mobile number.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_otpLength, (index) {
                  return SizedBox(
                    width: 44,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < _otpLength - 1) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                          }
                        } else {
                          if (index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Resend Code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive the code? ',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: _isSending ? null : _sendCode,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Verify & Proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}