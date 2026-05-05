import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

enum DoseStatus { taken, missed, pending }

enum TimePeriod { morning, afternoon, evening }

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final TimePeriod period;
  DoseStatus status;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.period,
    required this.status,
  });
}

class MedicationSchedulePage extends StatefulWidget {
  const MedicationSchedulePage({super.key});

  @override
  State<MedicationSchedulePage> createState() => _MedicationSchedulePageState();
}

class _MedicationSchedulePageState extends State<MedicationSchedulePage> {
  final List<Medication> _medications = [
    Medication(id: '1', name: 'Metformin', dosage: '500mg', time: '08:00 AM', period: TimePeriod.morning, status: DoseStatus.taken),
    Medication(id: '2', name: 'Vitamin D', dosage: '1000 IU', time: '08:30 AM', period: TimePeriod.morning, status: DoseStatus.taken),
    Medication(id: '3', name: 'Lisinopril', dosage: '10mg', time: '01:00 PM', period: TimePeriod.afternoon, status: DoseStatus.taken),
    Medication(id: '4', name: 'Aspirin', dosage: '81mg', time: '06:00 PM', period: TimePeriod.evening, status: DoseStatus.pending),
    Medication(id: '5', name: 'Atorvastatin', dosage: '20mg', time: '09:00 PM', period: TimePeriod.evening, status: DoseStatus.pending),
  ];

  void _updateStatus(String id, DoseStatus status) {
    setState(() {
      final index = _medications.indexWhere((m) => m.id == id);
      if (index != -1) {
        _medications[index].status = status;
      }
    });
  }

  void _showAddMedicationDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final timeController = TextEditingController();
    TimePeriod selectedPeriod = TimePeriod.morning;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Medication',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField('Medication Name', nameController, 'e.g., Metformin'),
                const SizedBox(height: 16),
                _buildTextField('Dosage', dosageController, 'e.g., 500mg'),
                const SizedBox(height: 16),
                _buildTextField('Time', timeController, 'e.g., 08:00 AM'),
                const SizedBox(height: 16),
                const Text(
                  'Period',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: TimePeriod.values.map((period) {
                    final isSelected = selectedPeriod == period;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => setDialogState(() => selectedPeriod = period),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.primaryGradient : null,
                              color: isSelected ? null : AppColors.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                period.name[0].toUpperCase() + period.name.substring(1),
                                style: TextStyle(
                                  color: isSelected ? Colors.black : AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                GradientButton(
                  text: 'Add Medication',
                  width: double.infinity,
                  onPressed: () {
                    if (nameController.text.isNotEmpty && dosageController.text.isNotEmpty && timeController.text.isNotEmpty) {
                      setState(() {
                        _medications.add(Medication(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text,
                          dosage: dosageController.text,
                          time: timeController.text,
                          period: selectedPeriod,
                          status: DoseStatus.pending,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final takenCount = _medications.where((m) => m.status == DoseStatus.taken).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medication Schedule',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Today, May 5th 2026',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
              GradientIconButton(
                icon: Icons.add,
                onPressed: _showAddMedicationDialog,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Progress
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Progress',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                      child: Text(
                        '$takenCount/${_medications.length} taken',
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _medications.isEmpty ? 0 : takenCount / _medications.length,
                    backgroundColor: AppColors.secondary,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryMint),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Timeline
          ...TimePeriod.values.map((period) => _buildPeriodSection(period)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPeriodSection(TimePeriod period) {
    final medications = _medications.where((m) => m.period == period).toList();
    if (medications.isEmpty) return const SizedBox();

    final periodData = _getPeriodData(period);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.medicalBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(periodData.icon, color: AppColors.medicalBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              periodData.label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.cardBorder, width: 2),
            ),
          ),
          child: Column(
            children: medications.map((med) => _buildMedicationCard(med)).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    final statusConfig = _getStatusConfig(medication.status);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Timeline Dot
        Positioned(
          left: -31,
          top: 24,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: statusConfig.color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.background, width: 2),
            ),
          ),
        ),
        GlassCard(
          margin: const EdgeInsets.only(bottom: 12),
          borderColor: medication.status == DoseStatus.pending ? AppColors.warning : null,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  color: AppColors.primaryMint,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      medication.dosage,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          medication.time,
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (medication.status == DoseStatus.pending) ...[
                _buildActionButton(
                  Icons.check,
                  AppColors.success,
                  () => _updateStatus(medication.id, DoseStatus.taken),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  Icons.close,
                  AppColors.error,
                  () => _updateStatus(medication.id, DoseStatus.missed),
                ),
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusConfig.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusConfig.label,
                    style: TextStyle(
                      color: statusConfig.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  _PeriodData _getPeriodData(TimePeriod period) {
    switch (period) {
      case TimePeriod.morning:
        return _PeriodData(Icons.wb_sunny_rounded, 'Morning');
      case TimePeriod.afternoon:
        return _PeriodData(Icons.wb_twilight_rounded, 'Afternoon');
      case TimePeriod.evening:
        return _PeriodData(Icons.nightlight_round, 'Evening');
    }
  }

  _StatusConfig _getStatusConfig(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return _StatusConfig(AppColors.success, 'Taken');
      case DoseStatus.missed:
        return _StatusConfig(AppColors.error, 'Missed');
      case DoseStatus.pending:
        return _StatusConfig(AppColors.warning, 'Pending');
    }
  }
}

class _PeriodData {
  final IconData icon;
  final String label;
  _PeriodData(this.icon, this.label);
}

class _StatusConfig {
  final Color color;
  final String label;
  _StatusConfig(this.color, this.label);
}
