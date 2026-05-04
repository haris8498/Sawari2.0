import 'package:flutter/material.dart';

class PassengerHomeTab extends StatefulWidget {
  const PassengerHomeTab({super.key});

  @override
  State<PassengerHomeTab> createState() => _PassengerHomeTabState();
}

class _PassengerHomeTabState extends State<PassengerHomeTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            isDark ? 'lib/assets/images/dark.png' : 'lib/assets/images/map.png',
            fit: BoxFit.cover,
          ),
        ),
        
        // 2. Floating Menu Button
        Positioned(
          top: 50,
          left: 16,
          child: Builder(
            builder: (context) {
              return FloatingActionButton(
                heroTag: 'menu_btn',
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 4,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(Icons.menu, color: theme.colorScheme.primary),
              );
            }
          ),
        ),
        
        // 3. Floating Location Picker Box
        Positioned(
          top: 60,
          left: 80,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pickup point',
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : const Color(0xFF475569)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gujrat Road, Gulshan Colony...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: isDark ? Colors.grey[600] : const Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
        
        // 4. Center Map Pin
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // 5. My Location Target Button
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.45,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'location_btn',
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 4,
            onPressed: () {},
            child: Icon(Icons.my_location, color: theme.colorScheme.primary),
          ),
        ),
        
        // 6. The Draggable Bottom Sheet
        _buildBottomSheet(),
      ],
    );
  }

  Widget _buildBottomSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                
                // Toll Road Warning
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? theme.colorScheme.primary.withOpacity(0.2) : const Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.circular(12),
                      border: isDark ? Border.all(color: theme.colorScheme.primary.withOpacity(0.3)) : null,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.toll, color: Color(0xFFD4AF37)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Toll roads aren\'t included in the fare.\nPlease pay them separately.',
                            style: TextStyle(
                              color: isDark ? theme.colorScheme.onSurface : Colors.white, 
                              fontSize: 13, 
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Vehicle Types
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildVehicleOption('Ride', 'lib/assets/images/car.png', isSelected: false),
                      const SizedBox(width: 16),
                      _buildVehicleOption('Rickshaw', 'lib/assets/images/car.png', icon: Icons.electric_rickshaw, isSelected: false),
                      const SizedBox(width: 16),
                      _buildVehicleOption('Moto', 'lib/assets/images/car.png', icon: Icons.two_wheeler, isSelected: false),
                      const SizedBox(width: 16),
                      _buildVehicleOption('City to City', 'lib/assets/images/car.png', isSelected: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Where to & for how much?',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7), 
                            fontSize: 16, 
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Quick Actions Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionItem(Icons.schedule, 'Scheduled', subtitle: 'Day 6:00 PM'),
                      _buildActionItem(Icons.add_location_alt_outlined, 'Add Stop'),
                      _buildActionItem(Icons.card_giftcard, 'Promotions'),
                      _buildActionItem(Icons.history, 'Ride History'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Promo Cards
                Container(
                  color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildPromoCard(
                              title: 'Share your ride',
                              imagePath: 'lib/assets/images/share.png', 
                              height: 100,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPromoCard(
                              title: 'Request a car',
                              imagePath: 'lib/assets/images/car.png',
                              height: 140,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: _buildPromoCard(
                          title: 'Send a parcel',
                          imagePath: 'lib/assets/images/percel.png',
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Footer: Confirm Button
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text('Confirm & Go', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.credit_card, size: 16, color: isDark ? Colors.grey[400] : const Color(0xFF475569)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Payment: Visa 4242', 
                                    style: TextStyle(
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Estimated Fare: \$15.50 - \$18.00', 
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehicleOption(String title, String imagePath, {IconData? icon, required bool isSelected}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 80,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.white.withOpacity(0.05) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: const Color(0xFFD4AF37), width: 1.5) : null,
          ),
          child: icon != null
              ? Icon(icon, size: 30, color: isSelected ? Colors.white : theme.colorScheme.onSurface)
              : Image.asset(imagePath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, {String? subtitle}) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(height: 6),
        Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 12, 
            color: theme.colorScheme.onSurface,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle, 
            style: TextStyle(
              fontSize: 10, 
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildPromoCard({required String title, required String imagePath, required double height}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 15, 
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(imagePath, height: height * 0.5, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
