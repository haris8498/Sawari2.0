import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
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
            _buildSettingsSection(
              context,
              'App Settings',
              [
                _buildSettingsItem(context, Icons.notifications_none, 'Push Notifications', trailing: Switch(value: true, onChanged: (v) {})),
                _buildSettingsItem(context, Icons.language, 'Language', trailing: const Text('English')),
                _buildSettingsItem(context, Icons.location_on_outlined, 'Location Accuracy', trailing: const Text('High')),
              ],
            ),
            const SizedBox(height: 32),
            _buildSettingsSection(
              context,
              'Account',
              [
                _buildSettingsItem(context, Icons.person_outline, 'Privacy Settings'),
                _buildSettingsItem(context, Icons.security, 'Security Checkup'),
                _buildSettingsItem(context, Icons.delete_outline, 'Delete Account', textColor: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> items) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[500] : const Color(0xFF64748B), letterSpacing: 1.1),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, {Widget? trailing, Color? textColor}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: textColor ?? theme.colorScheme.primary),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor ?? theme.colorScheme.onSurface)),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () {},
    );
  }
}
