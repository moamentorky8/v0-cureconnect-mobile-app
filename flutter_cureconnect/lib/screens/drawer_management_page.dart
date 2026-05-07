import 'dart:ui';
import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/glass_card.dart';
import 'package:provider/provider.dart';

class DrawerManagementPage extends StatefulWidget {
  const DrawerManagementPage({super.key});

  @override
  State<DrawerManagementPage> createState() => _DrawerManagementPageState();
}

class _DrawerManagementPageState extends State<DrawerManagementPage> {
  final List<Map<String, dynamic>> _drawers = List.generate(10, (index) => {
    'id': index + 1,
    'medicineName': index < 5 ? ['Aspirin', 'Metformin', 'Lisinopril', 'Omeprazole', 'Atorvastatin'][index] : '',
    'medicineNameAr': index < 5 ? ['أسبرين', 'ميتفورمين', 'ليسينوبريل', 'أوميبرازول', 'أتورفاستاتين'][index] : '',
    'alarmEnabled': index < 5,
    'alarmTime': index < 5 ? TimeOfDay(hour: 8 + (index * 4), minute: 0) : null,
    'pillCount': index < 5 ? 20 - (index * 2) : 0,
    'isActive': index < 5,
    'voiceSample': null,
    'reminderText': '',
    'lastDoseTime': index < 3 ? DateTime.now().subtract(Duration(hours: index * 6)) : null,
  });

  bool _wifiConnected = true;
  bool _esp32Connected = true;
  int? _selectedDrawerIndex;

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
          child: Column(
            children: [
              // Header
              _buildHeader(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n),
              
              // Hardware Status
              _buildHardwareStatus(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n),
              
              // Drawers Grid
              Expanded(
                child: _buildDrawersGrid(isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n) {
    return Padding(
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
              Icons.grid_view_rounded,
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
                  l10n.get('drawer_management'),
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_drawers.where((d) => d['isActive']).length}/10 ${l10n.get('drawers')}',
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

  Widget _buildHardwareStatus(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        backgroundColor: cardColor,
        borderColor: borderColor,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatusIndicator(
                icon: Icons.wifi_rounded,
                label: l10n.get('wifi_status'),
                status: _wifiConnected ? l10n.get('connected') : l10n.get('disconnected'),
                isConnected: _wifiConnected,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: borderColor,
            ),
            Expanded(
              child: _buildStatusIndicator(
                icon: Icons.memory_rounded,
                label: l10n.get('esp32_status'),
                status: _esp32Connected ? l10n.get('connected') : l10n.get('disconnected'),
                isConnected: _esp32Connected,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: borderColor,
            ),
            Expanded(
              child: _buildStatusIndicator(
                icon: Icons.sensors_rounded,
                label: l10n.get('ir_sensor'),
                status: l10n.get('connected'),
                isConnected: true,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required String status,
    required bool isConnected,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isConnected ? Colors.green : Colors.red,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: textSecondary,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: (isConnected ? Colors.green : Colors.red).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: isConnected ? Colors.green : Colors.red,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawersGrid(bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: _drawers.length,
        itemBuilder: (context, index) => _buildDrawerCard(
          index, isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic,
        ),
      ),
    );
  }

  Widget _buildDrawerCard(int index, bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n, bool isArabic) {
    final drawer = _drawers[index];
    final isActive = drawer['isActive'];
    final medicineName = isArabic ? drawer['medicineNameAr'] : drawer['medicineName'];

    return GestureDetector(
      onTap: () => _showDrawerSettings(index, isDark, cardColor, textPrimary, textSecondary, borderColor, l10n, isArabic),
      child: GlassCard(
        backgroundColor: cardColor,
        borderColor: isActive ? AppThemes.turquoise.withOpacity(0.5) : borderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: isActive 
                        ? const LinearGradient(colors: [AppThemes.turquoise, Color(0xFF00C4D9)])
                        : null,
                    color: isActive ? null : borderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${drawer['id']}',
                      style: TextStyle(
                        color: isActive ? Colors.black : textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Switch(
                  value: drawer['alarmEnabled'],
                  onChanged: (value) {
                    setState(() {
                      _drawers[index]['alarmEnabled'] = value;
                    });
                  },
                  activeColor: AppThemes.turquoise,
                  activeTrackColor: AppThemes.turquoise.withOpacity(0.3),
                ),
              ],
            ),
            const Spacer(),
            if (isActive) ...[
              Text(
                medicineName.isEmpty ? '${l10n.get('drawer')} ${drawer['id']}' : medicineName,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    drawer['alarmTime'] != null 
                        ? '${drawer['alarmTime'].hour.toString().padLeft(2, '0')}:${drawer['alarmTime'].minute.toString().padLeft(2, '0')}'
                        : '--:--',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppThemes.turquoise.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${drawer['pillCount']} ${l10n.get('pills_remaining')}',
                      style: const TextStyle(
                        color: AppThemes.turquoise,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                '${l10n.get('drawer')} ${drawer['id']}',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.get('add'),
                style: TextStyle(
                  color: AppThemes.turquoise,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDrawerSettings(int index, bool isDark, Color cardColor, Color textPrimary, 
      Color textSecondary, Color borderColor, AppLocalizations l10n, bool isArabic) {
    final drawer = _drawers[index];
    final medicineController = TextEditingController(
      text: isArabic ? drawer['medicineNameAr'] : drawer['medicineName'],
    );
    final pillCountController = TextEditingController(
      text: drawer['pillCount'].toString(),
    );
    final reminderTextController = TextEditingController(
      text: drawer['reminderText'],
    );
    TimeOfDay selectedTime = drawer['alarmTime'] ?? const TimeOfDay(hour: 8, minute: 0);
    bool alarmEnabled = drawer['alarmEnabled'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor),
          ),
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
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
                        child: Center(
                          child: Text(
                            '${drawer['id']}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${l10n.get('drawer_settings')} ${drawer['id']}',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, color: textSecondary),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medicine Name
                        _buildTextField(
                          controller: medicineController,
                          label: l10n.get('medicine_name'),
                          icon: Icons.medication_rounded,
                          isDark: isDark,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          borderColor: borderColor,
                        ),
                        const SizedBox(height: 20),

                        // Alarm Time
                        Text(
                          l10n.get('alarm_time'),
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTime,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: AppThemes.turquoise,
                                            surface: cardColor,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (time != null) {
                                    setModalState(() => selectedTime = time);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        color: AppThemes.turquoise,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          color: textPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  l10n.get('set_alarm'),
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                Switch(
                                  value: alarmEnabled,
                                  onChanged: (value) {
                                    setModalState(() => alarmEnabled = value);
                                  },
                                  activeColor: AppThemes.turquoise,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Pill Count
                        _buildTextField(
                          controller: pillCountController,
                          label: l10n.get('pill_count'),
                          icon: Icons.medication_liquid_rounded,
                          isDark: isDark,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          borderColor: borderColor,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),

                        // Voice Reminder Section
                        Text(
                          l10n.get('voice_reminder'),
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            children: [
                              // Upload Voice Sample
                              GestureDetector(
                                onTap: () {
                                  // TODO: Implement voice sample upload
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppThemes.turquoise.withOpacity(0.3),
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mic_rounded,
                                        color: AppThemes.turquoise,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.get('upload_voice'),
                                        style: const TextStyle(
                                          color: AppThemes.turquoise,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Text to Speech
                              Text(
                                l10n.get('text_to_speech'),
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: reminderTextController,
                                maxLines: 3,
                                style: TextStyle(color: textPrimary),
                                decoration: InputDecoration(
                                  hintText: l10n.get('enter_reminder_text'),
                                  hintStyle: TextStyle(color: textSecondary),
                                  filled: true,
                                  fillColor: cardColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppThemes.turquoise),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // TODO: Implement ElevenLabs TTS
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppThemes.turquoise,
                                    side: const BorderSide(color: AppThemes.turquoise),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.record_voice_over_rounded),
                                  label: Text(l10n.get('generate_voice')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Confirm Dose Button
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.green,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.get('confirm_dose'),
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: Confirm dose taken
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.get('dose_logged')),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.get('mark_as_taken'),
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Save Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _drawers[index]['medicineName'] = medicineController.text;
                          _drawers[index]['medicineNameAr'] = medicineController.text;
                          _drawers[index]['alarmTime'] = selectedTime;
                          _drawers[index]['alarmEnabled'] = alarmEnabled;
                          _drawers[index]['pillCount'] = int.tryParse(pillCountController.text) ?? 0;
                          _drawers[index]['reminderText'] = reminderTextController.text;
                          _drawers[index]['isActive'] = medicineController.text.isNotEmpty;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.turquoise,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.get('save'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color borderColor,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppThemes.turquoise),
            filled: true,
            fillColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppThemes.turquoise),
            ),
          ),
        ),
      ],
    );
  }
}
