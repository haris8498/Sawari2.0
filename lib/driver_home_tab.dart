import 'package:flutter/material.dart';

class DriverHomeTab extends StatefulWidget {
  const DriverHomeTab({super.key});

  @override
  State<DriverHomeTab> createState() => _DriverHomeTabState();
}

class _DriverHomeTabState extends State<DriverHomeTab> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // 1. Map Background
        SizedBox.expand(
          child: Image.asset(
            isDark ? 'lib/assets/images/dark.png' : 'lib/assets/images/map.png',
            fit: BoxFit.cover,
          ),
        ),

        // 2. Dim Overlay when Offline
        if (!isOnline)
          Positioned.fill(
            child: Container(
              color: isDark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.5),
            ),
          ),

        // 3. Floating Menu Button
        Positioned(
          top: topPadding + 12,
          left: 16,
          child: Builder(
              builder: (context) {
                return FloatingActionButton(
                  heroTag: 'driver_menu_btn',
                  backgroundColor: theme.scaffoldBackgroundColor,
                  elevation: 2,
                  mini: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  child: Icon(Icons.menu, color: theme.colorScheme.primary),
                );
              }
          ),
        ),

        // 4. Status Indicator (Top Center)
        Positioned(
          top: topPadding + 12,
          left: 80,
          right: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF10B981).withOpacity(0.9) // Emerald Green
                  : theme.scaffoldBackgroundColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Center(
              child: Text(
                isOnline ? 'You are Online' : 'You are Offline',
                style: TextStyle(
                  color: isOnline ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),

        // 5. Center Map Pin (Only visible when online)
        if (isOnline)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.15), shape: BoxShape.circle),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(color: theme.colorScheme.primary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // 6. Center "GO" Button (Visible when offline)
        if (!isOnline)
          Center(
            child: GestureDetector(
              onTap: () => setState(() => isOnline = true),
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                  boxShadow: [
                    BoxShadow(color: theme.colorScheme.primary.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3), width: 8),
                ),
                child: const Center(
                  child: Text(
                    'GO',
                    style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ),
              ),
            ),
          ),

        // 7. Earnings Bottom Sheet
        _buildDriverBottomSheet(),
      ],
    );
  }

  Widget _buildDriverBottomSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.15,
      maxChildSize: 0.6,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(isDark ? 0.4 : 0.08), blurRadius: 24, offset: const Offset(0, -4)),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(color: isDark ? Colors.grey[700] : const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                // Offline/Online Toggle Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Accepting Rides', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
                          const SizedBox(height: 4),
                          Text(isOnline ? 'You are visible to passengers' : 'Go online to start earning', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                      Switch(
                        value: isOnline,
                        activeColor: const Color(0xFF10B981),
                        onChanged: (val) => setState(() => isOnline = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Today's Summary
                Text('Today\'s Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildSummaryCard('Earnings', '\$84.50', Icons.attach_money, const Color(0xFF10B981))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSummaryCard('Trips', '12', Icons.route_outlined, theme.colorScheme.primary)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildSummaryCard('Time Online', '4h 30m', Icons.access_time, const Color(0xFFF59E0B))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSummaryCard('Acceptance', '94%', Icons.check_circle_outline, const Color(0xFF6366F1))),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.grey[400] : const Color(0xFF64748B))),
        ],
      ),
    );
  }
}