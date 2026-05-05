import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

enum SyncStatus { synced, syncing, error }

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _notifications = true;
  bool _voiceAlerts = true;
  bool _autoSync = true;
  bool _darkMode = true;
  SyncStatus _syncStatus = SyncStatus.synced;

  final _firebaseConfig = {
    'projectId': 'cureconnect-xxxxx',
    'databaseUrl': 'https://cureconnect-xxxxx.firebaseio.com',
    'apiKey': 'AIza...',
  };

  final _voiceSettings = {
    'apiKey': 'sk-...',
    'voiceId': 'rachel',
    'language': 'en-US',
  };

  void _handleSync() {
    setState(() => _syncStatus = SyncStatus.syncing);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _syncStatus = SyncStatus.synced);
    });
  }

  void _showFirebaseDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildConfigDialog(
        'Firebase Configuration',
        [
          _DialogField('Project ID', _firebaseConfig['projectId']!),
          _DialogField('Database URL', _firebaseConfig['databaseUrl']!),
          _DialogField('API Key', _firebaseConfig['apiKey']!, isPassword: true),
        ],
      ),
    );
  }

  void _showVoiceDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildConfigDialog(
        'Voice Settings',
        [
          _DialogField('ElevenLabs API Key', _voiceSettings['apiKey']!, isPassword: true),
          _DialogField('Voice', _voiceSettings['voiceId']!, isDropdown: true, options: [
            'Rachel (Female)',
            'Adam (Male)',
            'Josh (Male)',
            'Bella (Female)',
          ]),
          _DialogField('Language', _voiceSettings['language']!, isDropdown: true, options: [
            'English (US)',
            'English (UK)',
            'Arabic (Egypt)',
            'Spanish',
          ]),
        ],
      ),
    );
  }

  Widget _buildConfigDialog(String title, List<_DialogField> fields) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...fields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.label,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  if (field.isDropdown)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: DropdownButton<String>(
                        value: field.options?.first,
                        isExpanded: true,
                        dropdownColor: AppColors.card,
                        underline: const SizedBox(),
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        items: field.options?.map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        )).toList(),
                        onChanged: (value) {},
                      ),
                    )
                  else
                    TextField(
                      obscureText: field.isPassword,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: field.value,
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.secondary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryMint),
                        ),
                      ),
                    ),
                ],
              ),
            )),
            const SizedBox(height: 8),
            GradientButton(
              text: 'Save Configuration',
              width: double.infinity,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
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
            'Settings',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Manage your profile and preferences',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Profile Card
          _buildProfileCard(),
          const SizedBox(height: 20),

          // Firebase Sync Status
          _buildFirebaseSyncCard(),
          const SizedBox(height: 20),

          // ElevenLabs Voice Settings
          _buildVoiceSettingsCard(),
          const SizedBox(height: 20),

          // Quick Settings
          _buildQuickSettings(),
          const SizedBox(height: 20),

          // Account Actions
          _buildAccountActions(),
          const SizedBox(height: 24),

          // App Info
          Center(
            child: Column(
              children: [
                Text(
                  'CureConnect v1.0.0',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                Text(
                  'Smart Medication Organizer',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Center(
              child: Text(
                'MA',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
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
                const Text(
                  'Moamen Abdel-Fattah',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'moamen@example.com',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Active Patient',
                      style: TextStyle(color: AppColors.success, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 24),
        ],
      ),
    );
  }

  Widget _buildFirebaseSyncCard() {
    return GlassCard(
      child: Column(
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
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cloud_rounded, color: AppColors.warning, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Firebase Sync',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Realtime Database',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              _buildSyncStatusBadge(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: _syncStatus == SyncStatus.syncing ? 'Syncing...' : 'Sync Now',
                  isLoading: _syncStatus == SyncStatus.syncing,
                  onPressed: _handleSync,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                height: 48,
                child: OutlinedButton(
                  onPressed: _showFirebaseDialog,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Configure',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSyncStatusBadge() {
    Color color;
    String label;
    Widget? leading;

    switch (_syncStatus) {
      case SyncStatus.synced:
        color = AppColors.success;
        label = 'Synced';
        leading = Icon(Icons.check, color: color, size: 14);
        break;
      case SyncStatus.syncing:
        color = AppColors.medicalBlue;
        label = 'Syncing';
        leading = SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        );
        break;
      case SyncStatus.error:
        color = AppColors.error;
        label = 'Error';
        leading = Icon(Icons.error_outline, color: color, size: 14);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading!,
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceSettingsCard() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: _showVoiceDialog,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.medicalBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.mic_rounded, color: AppColors.medicalBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Voice Preferences',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'ElevenLabs API',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSettings() {
    final settings = [
      _SettingItem(Icons.notifications_rounded, 'Push Notifications', 'Medication reminders', _notifications, (v) => setState(() => _notifications = v)),
      _SettingItem(Icons.volume_up_rounded, 'Voice Alerts', 'Spoken reminders via ESP32', _voiceAlerts, (v) => setState(() => _voiceAlerts = v)),
      _SettingItem(Icons.sync_rounded, 'Auto Sync', 'Sync data automatically', _autoSync, (v) => setState(() => _autoSync = v)),
      _SettingItem(Icons.dark_mode_rounded, 'Dark Mode', 'Always enabled', _darkMode, null, disabled: true),
    ];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Settings',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...settings.map((setting) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(setting.icon, color: AppColors.primaryMint, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        setting.label,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        setting.description,
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: setting.value,
                  onChanged: setting.disabled ? null : setting.onChanged,
                  activeColor: AppColors.primaryMint,
                  activeTrackColor: AppColors.primaryMint.withValues(alpha: 0.3),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAccountActions() {
    return Column(
      children: [
        _buildActionButton(Icons.person_rounded, 'Edit Profile'),
        const SizedBox(height: 12),
        _buildActionButton(Icons.security_rounded, 'Privacy & Security'),
        const SizedBox(height: 12),
        _buildActionButton(Icons.logout_rounded, 'Sign Out', isDestructive: true),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool isDestructive = false}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDestructive ? AppColors.error.withValues(alpha: 0.5) : AppColors.cardBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isDestructive ? AppColors.error : AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (!isDestructive)
                  Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogField {
  final String label;
  final String value;
  final bool isPassword;
  final bool isDropdown;
  final List<String>? options;

  _DialogField(this.label, this.value, {this.isPassword = false, this.isDropdown = false, this.options});
}

class _SettingItem {
  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final Function(bool)? onChanged;
  final bool disabled;

  _SettingItem(this.icon, this.label, this.description, this.value, this.onChanged, {this.disabled = false});
}
