import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class PatientInfoPage extends StatefulWidget {
  const PatientInfoPage({super.key});

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  bool _isEditing = false;

  // Patient Data
  final Map<String, dynamic> _patientData = {
    'name': 'Moamen Abdel-Fattah',
    'patientId': 'CC-2024-00142',
    'dateOfBirth': '15 March 1995',
    'age': 29,
    'gender': 'Male',
    'bloodType': 'O+',
    'height': '175 cm',
    'weight': '72 kg',
    'bmi': '23.5',
    'phone': '+20 123 456 7890',
    'email': 'moamen@example.com',
    'address': '123 Medical Street, Cairo, Egypt',
    'emergencyContact': 'Ahmed Abdel-Fattah',
    'emergencyPhone': '+20 111 222 3333',
    'insuranceProvider': 'MedCare Insurance',
    'insuranceNumber': 'MCI-9876543',
    'primaryPhysician': 'Dr. Sarah Johnson',
    'physicianPhone': '+20 100 200 3000',
  };

  final List<Map<String, dynamic>> _medicalConditions = [
    {'condition': 'Hypertension', 'since': '2020', 'status': 'Controlled'},
    {'condition': 'Type 2 Diabetes', 'since': '2021', 'status': 'Monitoring'},
    {'condition': 'Mild Asthma', 'since': '2015', 'status': 'Controlled'},
  ];

  final List<Map<String, dynamic>> _allergies = [
    {'allergen': 'Penicillin', 'severity': 'High', 'reaction': 'Anaphylaxis'},
    {'allergen': 'Peanuts', 'severity': 'Medium', 'reaction': 'Hives'},
    {'allergen': 'Latex', 'severity': 'Low', 'reaction': 'Skin irritation'},
  ];

  final List<Map<String, dynamic>> _currentMedications = [
    {'name': 'Metformin', 'dosage': '500mg', 'frequency': 'Twice daily'},
    {'name': 'Lisinopril', 'dosage': '10mg', 'frequency': 'Once daily'},
    {'name': 'Ventolin Inhaler', 'dosage': '100mcg', 'frequency': 'As needed'},
  ];

  final List<Map<String, dynamic>> _recentVisits = [
    {'date': '28 Apr 2024', 'type': 'Routine Checkup', 'doctor': 'Dr. Sarah Johnson'},
    {'date': '15 Mar 2024', 'type': 'Blood Work', 'doctor': 'Lab Services'},
    {'date': '02 Feb 2024', 'type': 'Cardiology', 'doctor': 'Dr. Ahmed Hassan'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildPatientCard(),
                  const SizedBox(height: 16),
                  _buildVitalsOverview(),
                  const SizedBox(height: 16),
                  _buildPersonalInfoSection(),
                  const SizedBox(height: 16),
                  _buildMedicalConditionsSection(),
                  const SizedBox(height: 16),
                  _buildAllergiesSection(),
                  const SizedBox(height: 16),
                  _buildCurrentMedicationsSection(),
                  const SizedBox(height: 16),
                  _buildEmergencyContactSection(),
                  const SizedBox(height: 16),
                  _buildInsuranceSection(),
                  const SizedBox(height: 16),
                  _buildRecentVisitsSection(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Patient Information',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: _isEditing ? AppColors.primaryGradient : null,
              color: _isEditing ? null : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: _isEditing ? null : Border.all(color: AppColors.cardBorder),
            ),
            child: IconButton(
              icon: Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onPressed: () => setState(() => _isEditing = !_isEditing),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Profile Picture
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mint.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _patientData['name'].split(' ').map((n) => n[0]).take(2).join(),
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Patient Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _patientData['name'],
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ID: ${_patientData['patientId']}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(Icons.cake, '${_patientData['age']} years'),
                      const SizedBox(width: 8),
                      _buildInfoChip(Icons.water_drop, _patientData['bloodType']),
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

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.mint),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsOverview() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.monitor_heart, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Current Vitals',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildVitalCard('Height', _patientData['height'], Icons.height, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildVitalCard('Weight', _patientData['weight'], Icons.fitness_center, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildVitalCard('BMI', _patientData['bmi'], Icons.speed, Colors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person,
      children: [
        _buildInfoRow('Full Name', _patientData['name']),
        _buildInfoRow('Date of Birth', _patientData['dateOfBirth']),
        _buildInfoRow('Gender', _patientData['gender']),
        _buildInfoRow('Blood Type', _patientData['bloodType']),
        _buildInfoRow('Phone', _patientData['phone']),
        _buildInfoRow('Email', _patientData['email']),
        _buildInfoRow('Address', _patientData['address']),
      ],
    );
  }

  Widget _buildMedicalConditionsSection() {
    return _buildSection(
      title: 'Medical Conditions',
      icon: Icons.medical_information,
      children: _medicalConditions.map((condition) => _buildConditionCard(condition)).toList(),
    );
  }

  Widget _buildConditionCard(Map<String, dynamic> condition) {
    Color statusColor;
    switch (condition['status']) {
      case 'Controlled':
        statusColor = Colors.green;
        break;
      case 'Monitoring':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  condition['condition'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Since ${condition['since']}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              condition['status'],
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergiesSection() {
    return _buildSection(
      title: 'Allergies',
      icon: Icons.warning_amber,
      iconColor: AppColors.error,
      children: _allergies.map((allergy) => _buildAllergyCard(allergy)).toList(),
    );
  }

  Widget _buildAllergyCard(Map<String, dynamic> allergy) {
    Color severityColor;
    switch (allergy['severity']) {
      case 'High':
        severityColor = Colors.red;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.yellow;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.dangerous, color: severityColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allergy['allergen'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reaction: ${allergy['reaction']}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              allergy['severity'],
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentMedicationsSection() {
    return _buildSection(
      title: 'Current Medications',
      icon: Icons.medication,
      children: _currentMedications.map((med) => _buildMedicationCard(med)).toList(),
    );
  }

  Widget _buildMedicationCard(Map<String, dynamic> medication) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient.scale(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication_liquid, color: AppColors.mint, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication['name'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.mint.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        medication['dosage'],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.mint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      medication['frequency'],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactSection() {
    return _buildSection(
      title: 'Emergency Contact',
      icon: Icons.emergency,
      iconColor: AppColors.error,
      children: [
        _buildInfoRow('Contact Name', _patientData['emergencyContact']),
        _buildInfoRow('Phone Number', _patientData['emergencyPhone']),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return _buildSection(
      title: 'Insurance Information',
      icon: Icons.health_and_safety,
      children: [
        _buildInfoRow('Provider', _patientData['insuranceProvider']),
        _buildInfoRow('Policy Number', _patientData['insuranceNumber']),
        _buildInfoRow('Primary Physician', _patientData['primaryPhysician']),
        _buildInfoRow('Physician Phone', _patientData['physicianPhone']),
      ],
    );
  }

  Widget _buildRecentVisitsSection() {
    return _buildSection(
      title: 'Recent Visits',
      icon: Icons.calendar_month,
      children: _recentVisits.map((visit) => _buildVisitCard(visit)).toList(),
    );
  }

  Widget _buildVisitCard(Map<String, dynamic> visit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit['type'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  visit['doctor'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            visit['date'],
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.mint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    Color iconColor = AppColors.mint,
    required List<Widget> children,
  }) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
