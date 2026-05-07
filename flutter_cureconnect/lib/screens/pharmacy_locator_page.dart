import 'dart:ui';
import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/glass_card.dart';
import 'package:provider/provider.dart';

class PharmacyLocatorPage extends StatefulWidget {
  const PharmacyLocatorPage({super.key});

  @override
  State<PharmacyLocatorPage> createState() => _PharmacyLocatorPageState();
}

class _PharmacyLocatorPageState extends State<PharmacyLocatorPage>
    with SingleTickerProviderStateMixin {
  bool _locationPermissionGranted = false;
  bool _isLoading = false;
  int _selectedPharmacyIndex = -1;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _pharmacies = [
    {
      'name': 'Al-Dawaa Pharmacy',
      'nameAr': 'صيدلية الدواء',
      'address': '123 Healthcare St, Medical District',
      'addressAr': '١٢٣ شارع الرعاية الصحية، الحي الطبي',
      'distance': 0.3,
      'rating': 4.8,
      'isOpen': true,
      'openUntil': '11:00 PM',
      'phone': '+966 12 345 6789',
      'lat': 24.7136,
      'lng': 46.6753,
    },
    {
      'name': 'Nahdi Pharmacy',
      'nameAr': 'صيدلية النهدي',
      'address': '456 Wellness Ave, Central Area',
      'addressAr': '٤٥٦ شارع العافية، المنطقة المركزية',
      'distance': 0.7,
      'rating': 4.6,
      'isOpen': true,
      'openUntil': '12:00 AM',
      'phone': '+966 12 987 6543',
      'lat': 24.7256,
      'lng': 46.6853,
    },
    {
      'name': 'Kunooz Pharmacy',
      'nameAr': 'صيدلية كنوز',
      'address': '789 Health Plaza, North Side',
      'addressAr': '٧٨٩ ساحة الصحة، الجهة الشمالية',
      'distance': 1.2,
      'rating': 4.5,
      'isOpen': false,
      'openUntil': 'Opens at 8:00 AM',
      'phone': '+966 12 456 7890',
      'lat': 24.7356,
      'lng': 46.6953,
    },
    {
      'name': 'Care Pharmacy',
      'nameAr': 'صيدلية كير',
      'address': '321 Medical Center Rd',
      'addressAr': '٣٢١ طريق المركز الطبي',
      'distance': 1.8,
      'rating': 4.7,
      'isOpen': true,
      'openUntil': '10:00 PM',
      'phone': '+966 12 321 0987',
      'lat': 24.7456,
      'lng': 46.7053,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _requestLocationPermission() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _locationPermissionGranted = true;
        _isLoading = false;
      });
    });
  }

  void _refreshLocation() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final l10n = AppLocalizations(appProvider.locale);
    final isDark = appProvider.isDarkMode;
    final isArabic = appProvider.isArabic;

    final bgColor = isDark ? Colors.black : const Color(0xFFF8FAFB);
    final cardColor = isDark ? const Color(0xFF0D0D0D) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6B7280);
    final borderColor = isDark ? const Color(0xFF1F1F1F) : const Color(0xFFE5E7EB);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: _locationPermissionGranted
              ? _buildMapView(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic)
              : _buildPermissionRequest(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n),
        ),
        floatingActionButton: _locationPermissionGranted
            ? FloatingActionButton.extended(
                onPressed: _refreshLocation,
                backgroundColor: AppThemes.turquoise,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(Icons.my_location_rounded, color: Colors.black),
                label: Text(
                  l10n.get('refresh_location'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildPermissionRequest(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassCard(
          backgroundColor: cardColor,
          borderColor: borderColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppThemes.turquoise, Color(0xFF00C4D9)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 48,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.get('location_permission'),
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.get('location_permission_desc'),
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _requestLocationPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.turquoise,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          l10n.get('allow_location'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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

  Widget _buildMapView(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n, bool isArabic) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppThemes.turquoise, Color(0xFF00C4D9)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.local_pharmacy_rounded,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.get('pharmacy_locator'),
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_pharmacies.length} ${l10n.get('nearby_pharmacies')}',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Map Placeholder
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE8F5F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor),
            ),
            child: Stack(
              children: [
                // Map background simulation
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF1A2A2A), const Color(0xFF0D1A1A)]
                            : [const Color(0xFFE8F5F3), const Color(0xFFD0F0EA)],
                      ),
                    ),
                    child: CustomPaint(
                      painter: _MapGridPainter(isDark: isDark),
                      size: Size.infinite,
                    ),
                  ),
                ),
                // User location marker
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 60 + (_pulseController.value * 40),
                        height: 60 + (_pulseController.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppThemes.turquoise.withOpacity(
                            0.3 * (1 - _pulseController.value),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppThemes.turquoise,
                              boxShadow: [
                                BoxShadow(
                                  color: AppThemes.turquoise,
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.my_location,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Pharmacy markers
                ..._buildPharmacyMarkers(isDark),
                // Google Maps attribution
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_rounded,
                          size: 14,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Google Maps',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Pharmacy List
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
            child: ListView.builder(
              itemCount: _pharmacies.length,
              itemBuilder: (context, index) => _buildPharmacyCard(
                index, isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPharmacyMarkers(bool isDark) {
    final positions = [
      const Offset(0.3, 0.25),
      const Offset(0.7, 0.35),
      const Offset(0.25, 0.65),
      const Offset(0.75, 0.7),
    ];

    return List.generate(_pharmacies.length, (index) {
      final pharmacy = _pharmacies[index];
      final isSelected = _selectedPharmacyIndex == index;
      
      return Positioned(
        left: positions[index].dx * 280,
        top: positions[index].dy * 200,
        child: GestureDetector(
          onTap: () => setState(() => _selectedPharmacyIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppThemes.turquoise 
                        : (pharmacy['isOpen'] ? Colors.green : Colors.red),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected 
                            ? AppThemes.turquoise 
                            : (pharmacy['isOpen'] ? Colors.green : Colors.red))
                            .withOpacity(0.5),
                        blurRadius: isSelected ? 12 : 6,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    size: isSelected ? 20 : 16,
                    color: Colors.white,
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      '${pharmacy['distance']} km',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPharmacyCard(int index, bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n, bool isArabic) {
    final pharmacy = _pharmacies[index];
    final isSelected = _selectedPharmacyIndex == index;
    final name = isArabic ? pharmacy['nameAr'] : pharmacy['name'];
    final address = isArabic ? pharmacy['addressAr'] : pharmacy['address'];

    return GestureDetector(
      onTap: () => setState(() => _selectedPharmacyIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppThemes.turquoise : borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppThemes.turquoise.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: pharmacy['isOpen']
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    color: pharmacy['isOpen'] ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: pharmacy['isOpen']
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pharmacy['isOpen']
                                  ? l10n.get('open_now')
                                  : l10n.get('closed'),
                              style: TextStyle(
                                color: pharmacy['isOpen']
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${pharmacy['rating']}',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${pharmacy['distance']} km',
                      style: TextStyle(
                        color: AppThemes.turquoise,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pharmacy['openUntil'],
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address,
              style: TextStyle(
                color: textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppThemes.turquoise,
                      side: const BorderSide(color: AppThemes.turquoise),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.directions_rounded, size: 18),
                    label: Text(l10n.get('get_directions')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.turquoise,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.phone_rounded, size: 18),
                    label: Text(l10n.get('call')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;

  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw grid lines
    for (var i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 30) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw some road-like lines
    final roadPaint = Paint()
      ..color = (isDark ? AppThemes.turquoise : const Color(0xFF40E0D0)).withOpacity(0.2)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
