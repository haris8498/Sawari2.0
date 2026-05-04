import 'package:flutter/material.dart';

class PassengerWalletTab extends StatelessWidget {
  const PassengerWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('My Wallet', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium Balance Card
            _buildPremiumBalanceCard(context),
            const SizedBox(height: 32),
            
            // Quick Actions Hub
            _buildSectionHeader(context, 'Quick Actions'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionChip(context, Icons.add_rounded, 'Top Up', const Color(0xFF6366F1)),
                _buildActionChip(context, Icons.swap_horiz_rounded, 'Transfer', const Color(0xFFF59E0B)),
                _buildActionChip(context, Icons.history_rounded, 'History', const Color(0xFF10B981)),
                _buildActionChip(context, Icons.more_horiz_rounded, 'More', const Color(0xFF64748B)),
              ],
            ),
            const SizedBox(height: 32),
            
            // Monthly Analytics (New professional touch)
            _buildAnalyticsCard(context),
            const SizedBox(height: 32),
            
            // Payment Methods
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(context, 'Payment Methods'),
                TextButton(
                  onPressed: () {},
                  child: Text('Add New', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPaymentCard(context, 'Visa Platinum', '**** 4242', 'lib/assets/images/car.png', isSelected: true),
            _buildPaymentCard(context, 'Mastercard Gold', '**** 8899', 'lib/assets/images/car.png'),
            _buildPaymentCard(context, 'Apple Pay', 'Linked', null, icon: Icons.apple, color: isDark ? Colors.white : Colors.black),
            
            const SizedBox(height: 32),
            
            // Recent Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(context, 'Recent Activity'),
                TextButton(
                  onPressed: () {},
                  child: Text('See All', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTransactionTile(context, 'Premium Ride', 'Today, 2:45 PM', '-\$24.50', Colors.redAccent, Icons.directions_car_filled),
            _buildTransactionTile(context, 'Wallet Top-up', 'Yesterday, 10:20 AM', '+\$100.00', const Color(0xFF10B981), Icons.account_balance_wallet_rounded),
            _buildTransactionTile(context, 'Ride Cancellation', 'May 02, 2024', '+\$5.00', const Color(0xFF10B981), Icons.refresh_rounded),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.w800, 
        color: Theme.of(context).colorScheme.onSurface,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildPremiumBalanceCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF1E293B), const Color(0xFF0F172A)] 
            : [theme.colorScheme.primary, theme.colorScheme.primary.withBlue(150)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : theme.colorScheme.primary).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Decorative shapes
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Balance',
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '\$2,450.50',
                            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _buildBalanceInfo('Income', '+\$12,400', Icons.arrow_upward),
                      const SizedBox(width: 40),
                      _buildBalanceInfo('Spend', '-\$8,240', Icons.arrow_downward),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String amount, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white.withOpacity(0.6)),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionChip(BuildContext context, IconData icon, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13, 
            fontWeight: FontWeight.w600, 
            color: isDark ? Colors.grey[400] : const Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_graph_rounded, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spend Analytics',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  'You spent 12% less than last month',
                  style: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, String name, String detail, String? imagePath, {bool isSelected = false, IconData? icon, Color? color}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: icon != null 
              ? Icon(icon, color: color ?? theme.colorScheme.primary)
              : (imagePath != null ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ) : Icon(Icons.credit_card, color: theme.colorScheme.primary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 2),
                Text(detail, style: TextStyle(color: isDark ? Colors.grey[500] : const Color(0xFF64748B), fontSize: 13)),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 24)
          else
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, String title, String date, String amount, Color amountColor, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: isDark ? Colors.grey[400] : const Color(0xFF475569), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: amountColor),
          ),
        ],
      ),
    );
  }
}
