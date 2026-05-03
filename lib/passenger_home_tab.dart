import 'package:flutter/material.dart';

class PassengerHomeTab extends StatefulWidget {
  const PassengerHomeTab({super.key});

  @override
  State<PassengerHomeTab> createState() => _PassengerHomeTabState();
}

class _PassengerHomeTabState extends State<PassengerHomeTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. The Map Placeholder (Using location image as a map proxy)
        SizedBox.expand(
          child: Image.asset(
            'lib/assets/images/map.png',
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
                backgroundColor: Colors.white,
                elevation: 4,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.menu, color: Color(0xFF0F265C)),
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
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                      const Text(
                        'Pickup point',
                        style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Gujrat Road, Gulshan Colony...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F265C),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),
        
        // 4. Center Map Pin
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0), // Offset for the pin tip
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
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
            backgroundColor: Colors.white,
            elevation: 4,
            onPressed: () {
              // Placeholder action
            },
            child: const Icon(Icons.my_location, color: Color(0xFF0F265C)),
          ),
        ),
        
        // 6. The Draggable Bottom Sheet
        _buildBottomSheet(),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Light grayish background
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
                      color: const Color(0xFFCBD5E1),
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
                      color: const Color(0xFF1E3A8A), // Deep blue
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.toll, color: Color(0xFFD4AF37)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Toll roads aren\'t included in the fare.\nPlease pay them separately.',
                            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
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
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Color(0xFF0F265C)),
                        SizedBox(width: 12),
                        Text(
                          'Where to & for how much?',
                          style: TextStyle(color: Color(0xFF0F265C), fontSize: 16, fontWeight: FontWeight.w500),
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
                
                // Promo Cards (Share ride, Request car, etc)
                Container(
                  color: Colors.white,
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
                              imagePath: 'lib/assets/images/car.png', 
                              height: 100,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPromoCard(
                              title: 'Request a car',
                              imagePath: 'lib/assets/images/car.png',
                              height: 140, // Taller card
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.47,
                        child: _buildPromoCard(
                          title: 'Send a parcel',
                          imagePath: 'lib/assets/images/car.png',
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
                                backgroundColor: const Color(0xFF0F265C),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text('Confirm & Go', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.credit_card, size: 16, color: Color(0xFF475569)),
                                  SizedBox(width: 4),
                                  Text('Payment: Visa 4242', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('Estimated Fare: \$15.50 - \$18.00', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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
    return Column(
      children: [
        Container(
          width: 80,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F265C) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: const Color(0xFFD4AF37), width: 1.5) : null,
          ),
          child: icon != null
              ? Icon(icon, size: 30, color: isSelected ? Colors.white : Colors.black87)
              : Image.asset(imagePath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0F265C) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, {String? subtitle}) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0F265C), size: 28),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F265C))),
        if (subtitle != null)
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
      ],
    );
  }

  Widget _buildPromoCard({required String title, required String imagePath, required double height}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
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
