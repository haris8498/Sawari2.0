import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  final String title;
  const HelpSupportScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildContactCard(
              context,
              'Live Chat',
              'Speak with our support team now.',
              Icons.chat_outlined,
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              context,
              'Email Support',
              'support@sawari.com',
              Icons.email_outlined,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              context,
              'Call Center',
              '+92 300 1234567',
              Icons.phone_outlined,
              Colors.green,
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(context, 'How to request a ride?'),
            _buildFaqItem(context, 'How to pay for my ride?'),
            _buildFaqItem(context, 'How to become a driver?'),
            _buildFaqItem(context, 'What is City to City?'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
        onTap: () {},
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(question, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface)),
        trailing: Icon(Icons.add, size: 20, color: theme.colorScheme.primary),
        onTap: () {},
      ),
    );
  }
}
