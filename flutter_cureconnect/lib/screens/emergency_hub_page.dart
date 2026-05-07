import 'dart:ui';
import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/glass_card.dart';
import 'package:provider/provider.dart';

class EmergencyHubPage extends StatefulWidget {
  const EmergencyHubPage({super.key});

  @override
  State<EmergencyHubPage> createState() => _EmergencyHubPageState();
}

class _EmergencyHubPageState extends State<EmergencyHubPage>
    with SingleTickerProviderStateMixin {
  bool _contactPermissionGranted = true;
  bool _isSendingAlert = false;
  late AnimationController _pulseController;

  // Alert settings
  bool _hardwareErrorAlert = true;
  bool _missedDoseAlert = true;
  bool _lowInventoryAlert = true;

  // Emergency Guardian
  Map<String, String>? _selectedGuardian = {
    'name': 'Ahmed Mohamed',
    'nameAr': 'أحمد محمد',
    'phone': '+966 50 123 4567',
    'relation': 'Father',
    'relationAr': 'الأب',
  };

  final List<Map<String, String>> _contacts = [
    {
      'name': 'Ahmed Mohamed',
      'nameAr': 'أحمد محمد',
      'phone': '+966 50 123 4567',
      'relation': 'Father',
      'relationAr': 'الأب',
    },
    {
      'name': 'Fatima Hassan',
      'nameAr': 'فاطمة حسن',
      'phone': '+966 55 987 6543',
      'relation': 'Mother',
      'relationAr': 'الأم',
    },
    {
      'name': 'Dr. Khalid Ali',
      'nameAr': 'د. خالد علي',
      'phone': '+966 54 456 7890',
      'relation': 'Doctor',
      'relationAr': 'الطبيب',
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

  void _sendTestAlert() {
    setState(() => _isSendingAlert = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isSendingAlert = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(AppLocalizations(context.read<AppProvider>().locale).get('alert_sent')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                _buildHeader(textPrimary, textSecondary, l10n),

                // Emergency Guardian Section
                _buildGuardianSection(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic),

                // Alert Settings Section
                _buildAlertSettings(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n),

                // Test Alert Button
                _buildTestAlertButton(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n),

                // Emergency Status
                _buildEmergencyStatus(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textPrimary, Color textSecondary, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEF4444).withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.emergency_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.get('emergency_hub'),
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _selectedGuardian != null 
                      ? '${l10n.get('emergency_guardian')}: ${_selectedGuardian!['name']}'
                      : l10n.get('select_guardian'),
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
    );
  }

  Widget _buildGuardianSection(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        backgroundColor: cardColor,
        borderColor: borderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_pin_rounded,
                  color: AppThemes.turquoise,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.get('emergency_guardian'),
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_selectedGuardian != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppThemes.turquoise.withOpacity(0.1),
                      AppThemes.turquoise.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppThemes.turquoise.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppThemes.turquoise, Color(0xFF00C4D9)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          _selectedGuardian!['name']!.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? _selectedGuardian!['nameAr']! : _selectedGuardian!['name']!,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedGuardian!['phone']!,
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppThemes.turquoise.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isArabic ? _selectedGuardian!['relationAr']! : _selectedGuardian!['relation']!,
                              style: const TextStyle(
                                color: AppThemes.turquoise,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showContactSelector(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic),
                      icon: Icon(
                        Icons.edit_rounded,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              GestureDetector(
                onTap: () => _showContactSelector(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppThemes.turquoise.withOpacity(0.3),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_add_rounded,
                        color: AppThemes.turquoise,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.get('select_guardian'),
                        style: const TextStyle(
                          color: AppThemes.turquoise,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAlertSettings(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        backgroundColor: cardColor,
        borderColor: borderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active_rounded,
                  color: AppThemes.turquoise,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.get('automated_alerts'),
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildAlertToggle(
              icon: Icons.error_outline_rounded,
              iconColor: Colors.red,
              label: l10n.get('hardware_error_alert'),
              description: 'ESP32 connection issues',
              value: _hardwareErrorAlert,
              onChanged: (value) => setState(() => _hardwareErrorAlert = value),
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              borderColor: borderColor,
            ),
            const SizedBox(height: 12),
            
            _buildAlertToggle(
              icon: Icons.alarm_off_rounded,
              iconColor: Colors.orange,
              label: l10n.get('missed_dose_alert'),
              description: 'Notify when dose is missed',
              value: _missedDoseAlert,
              onChanged: (value) => setState(() => _missedDoseAlert = value),
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              borderColor: borderColor,
            ),
            const SizedBox(height: 12),
            
            _buildAlertToggle(
              icon: Icons.inventory_2_rounded,
              iconColor: Colors.amber,
              label: l10n.get('low_inventory_alert'),
              description: 'When pills count is low',
              value: _lowInventoryAlert,
              onChanged: (value) => setState(() => _lowInventoryAlert = value),
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              borderColor: borderColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertToggle({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textPrimary,
    required Color textSecondary,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: iconColor,
            activeTrackColor: iconColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildTestAlertButton(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: _isSendingAlert ? null : _sendTestAlert,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withOpacity(
                      0.4 + (_pulseController.value * 0.2),
                    ),
                    blurRadius: 20 + (_pulseController.value * 10),
                    spreadRadius: 2 + (_pulseController.value * 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _isSendingAlert
                      ? const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.campaign_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.get('test_alert'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.get('send_test_alert'),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmergencyStatus(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        backgroundColor: cardColor,
        borderColor: borderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety_rounded,
                  color: Colors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'System Status',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildStatusRow(
              icon: Icons.wifi_rounded,
              label: 'WiFi Connection',
              status: 'Connected',
              isGood: true,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              icon: Icons.memory_rounded,
              label: 'ESP32 Device',
              status: 'Online',
              isGood: true,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              icon: Icons.sms_rounded,
              label: 'SMS Service',
              status: 'Ready',
              isGood: true,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              icon: Icons.notification_important_rounded,
              label: 'Push Notifications',
              status: 'Enabled',
              isGood: true,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required String label,
    required String status,
    required bool isGood,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      children: [
        Icon(icon, color: textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: textPrimary,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (isGood ? Colors.green : Colors.red).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isGood ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  color: isGood ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showContactSelector(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n, bool isArabic) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor),
        ),
        child: Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                l10n.get('select_guardian'),
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              ...List.generate(_contacts.length, (index) {
                final contact = _contacts[index];
                final isSelected = _selectedGuardian?['name'] == contact['name'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedGuardian = contact);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppThemes.turquoise.withOpacity(0.1) 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppThemes.turquoise : borderColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: isSelected 
                                ? const LinearGradient(colors: [AppThemes.turquoise, Color(0xFF00C4D9)])
                                : null,
                            color: isSelected ? null : borderColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              contact['name']!.substring(0, 2).toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? Colors.black : textSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? contact['nameAr']! : contact['name']!,
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${contact['phone']} • ${isArabic ? contact['relationAr'] : contact['relation']}',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppThemes.turquoise,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
