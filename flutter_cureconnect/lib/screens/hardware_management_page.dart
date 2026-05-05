import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class HardwareManagementPage extends StatefulWidget {
  const HardwareManagementPage({super.key});

  @override
  State<HardwareManagementPage> createState() => _HardwareManagementPageState();
}

class _HardwareManagementPageState extends State<HardwareManagementPage> {
  int _ldrValue = 720;
  String _ldrStatus = 'bright';
  bool _alarmActive = false;
  String _lastPing = '2 seconds ago';
  double _pwmIntensity = 75;
  bool _autoMode = true;
  bool _isRefreshing = false;
  bool _alarmTriggered = false;

  void _handleRefresh() {
    setState(() => _isRefreshing = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _ldrValue = Random().nextInt(1024);
          _ldrStatus = _ldrValue > 700 ? 'bright' : (_ldrValue > 300 ? 'dim' : 'dark');
          _lastPing = 'Just now';
          _isRefreshing = false;
        });
      }
    });
  }

  void _handleTriggerAlarm() {
    setState(() {
      _alarmTriggered = true;
      _alarmActive = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _alarmTriggered = false;
          _alarmActive = false;
        });
      }
    });
  }

  Color _getLdrStatusColor() {
    switch (_ldrStatus) {
      case 'bright':
        return AppColors.warning;
      case 'dim':
        return AppColors.primaryMint;
      case 'dark':
        return AppColors.medicalBlue;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Hardware Management',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'ESP32 Smart Medication Organizer',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Device Status Card
          _buildDeviceStatusCard(),
          const SizedBox(height: 20),

          // LDR Sensor Status
          _buildLdrSensorCard(),
          const SizedBox(height: 20),

          // PWM LED Control
          _buildPwmControlCard(),
          const SizedBox(height: 20),

          // Manual Alarm Trigger
          _buildAlarmCard(),
          const SizedBox(height: 20),

          // Device Info
          _buildDeviceInfoCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildDeviceStatusCard() {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.medicalBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.memory_rounded, color: AppColors.medicalBlue, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESP32-WROOM-32',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Medication Organizer v1.2',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _handleRefresh,
                child: AnimatedRotation(
                  turns: _isRefreshing ? 1 : 0,
                  duration: const Duration(seconds: 1),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  Icons.wifi_rounded,
                  AppColors.success,
                  'Connection',
                  'Online',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusItem(
                  Icons.timeline_rounded,
                  AppColors.primaryMint,
                  'Last Ping',
                  _lastPing,
                  AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, Color iconColor, String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLdrSensorCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.wb_sunny_rounded, color: AppColors.warning, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LDR Light Sensor',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Ambient light detection',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Reading',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                          child: Text(
                            '$_ldrValue',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          ' / 1024',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.lightbulb_rounded, color: _getLdrStatusColor(), size: 32),
                    const SizedBox(height: 4),
                    Text(
                      _ldrStatus[0].toUpperCase() + _ldrStatus.substring(1),
                      style: TextStyle(
                        color: _getLdrStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _ldrValue / 1024,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.medicalBlue, AppColors.primaryMint, AppColors.warning],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dark', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text('Dim', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text('Bright', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPwmControlCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryMint.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune_rounded, color: AppColors.primaryMint, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PWM LED Control',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Indicator brightness',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Auto', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(width: 8),
                  Switch(
                    value: _autoMode,
                    onChanged: (value) => setState(() => _autoMode = value),
                    activeColor: AppColors.primaryMint,
                    activeTrackColor: AppColors.primaryMint.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: _autoMode ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: _autoMode,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Intensity', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      ShaderMask(
                        shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          '${_pwmIntensity.round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      activeTrackColor: AppColors.primaryMint,
                      inactiveTrackColor: AppColors.secondary,
                      thumbColor: AppColors.primaryCyan,
                    ),
                    child: Slider(
                      value: _pwmIntensity,
                      min: 0,
                      max: 100,
                      onChanged: (value) => setState(() => _pwmIntensity = value),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Off', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      Text('50%', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      Text('Max', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_active_rounded, color: AppColors.error, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manual Alarm',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Test medication reminder',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alarm Status',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    Text(
                      _alarmActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: _alarmActive ? AppColors.error : AppColors.success,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _alarmActive ? AppColors.error : AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: _alarmActive
                        ? [BoxShadow(color: AppColors.error.withValues(alpha: 0.5), blurRadius: 8)]
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _alarmTriggered ? null : _handleTriggerAlarm,
              icon: const Icon(Icons.notifications_active_rounded, size: 18),
              label: Text(_alarmTriggered ? 'Alarm Triggered!' : 'Trigger Manual Alarm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
    final deviceInfo = [
      {'label': 'Firmware Version', 'value': 'v1.2.3'},
      {'label': 'MAC Address', 'value': 'A4:CF:12:XX:XX:XX'},
      {'label': 'IP Address', 'value': '192.168.1.105'},
      {'label': 'Uptime', 'value': '5 days, 12 hours'},
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Device Information',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...deviceInfo.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['label']!,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                Text(
                  item['value']!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
