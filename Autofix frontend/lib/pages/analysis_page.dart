import 'package:autofix_car/constants/app_styles.dart';
import 'package:autofix_car/pages/dashboard_light_scanning_page.dart';
import 'package:autofix_car/pages/engine_diagnosis_page.dart';
import 'package:autofix_car/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autofix_car/constants/app_colors.dart';
import 'package:autofix_car/widgets/diagnostic_card.dart';
import './manual_fault_entry_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF1E3A5F),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'analysis'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildWelcomeSection(context),
              _buildDiagnosticMethods(context),
              _buildSmartInsights(context),
              _buildHealthDashboard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'comprehensive_analysis'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ai_powered_diagnostics_description'.tr(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticMethods(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'diagnostic_methods'.tr(),
            style: AppStyles.headline2.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: PageView(
              controller: PageController(viewportFraction: 0.85),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildModernDiagnosticCard(
                  context,
                  title: 'dashboard_light_scan'.tr(),
                  subtitle: 'instant_warning_analysis'.tr(),
                  description: 'ai_dashboard_description'.tr(),
                  icon: Icons.dashboard_customize,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  onTap: () => _navigateToPage(
                    context,
                    const DashboardLightScanningPage(),
                  ),
                ),
                _buildModernDiagnosticCard(
                  context,
                  title: 'engine_sound_analysis'.tr(),
                  subtitle: 'advanced_audio_diagnostics'.tr(),
                  description: 'engine_sound_description'.tr(),
                  icon: Icons.graphic_eq,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                  ),
                  onTap: () =>
                      _navigateToPage(context, const EngineDiagnosisPage()),
                ),
                _buildModernDiagnosticCard(
                  context,
                  title: 'manual_inspection'.tr(),
                  subtitle: 'guided_visual_check'.tr(),
                  description: 'manual_inspection_description'.tr(),
                  icon: Icons.search,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
                  ),
                  onTap: () =>
                      _navigateToPage(context, const ManualFaultEntryPage()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDiagnosticCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
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

  Widget _buildSmartInsights(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'smart_insights'.tr(),
                    style: AppStyles.headline3.copyWith(
                      color: AppColors.titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ai_powered_suggestions'.tr(),
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.greyTextColor,
                      fontSize: AppStyles.bodyText1.fontSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInsightItem(
            'start_dashboard_scan'.tr(),
            'dashboard_scan_recommendation'.tr(),
            Icons.priority_high,
            Colors.amber,
          ),
          _buildInsightItem(
            'try_engine_analysis'.tr(),
            'engine_analysis_recommendation'.tr(),
            Icons.hearing,
            Colors.green,
          ),
          _buildInsightItem(
            'schedule_preventive_check'.tr(),
            'preventive_check_reminder'.tr(),
            Icons.event_available,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppStyles.bodyText2.copyWith(
                    color: AppColors.greyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDashboard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.health_and_safety_outlined,
                  color: Colors.green,
                  size: 16,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Health Status',
                      style: AppStyles.headline2.copyWith(
                        color: AppColors.titleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Overall condition: Excellent',
                      style: AppStyles.bodyText1.copyWith(
                        color: AppColors.successColor,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) async {
              if (value == 'download') {
              await _downloadReport(context);
              }
              },
              itemBuilder: (context) => [
              const PopupMenuItem<String>(
              value: 'download',
              child: Text('Download Report'),
              ),
              ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Health metrics
          Row(
            children: [
              Expanded(child: _buildHealthMetric('Engine', 95, Colors.green)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHealthMetric('Transmission', 92, Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildHealthMetric('Brakes', 88, Colors.amber)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(String label, int percentage, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: percentage / 100,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 6,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Helper methods
  // Removed duplicate and unused _navigateToPage method to fix naming conflict.

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const Center(child: Text('Notifications Panel')),
      ),
    );
  }

  void _showAllMethods(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Customize diagnostic methods'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }


  
  Future<void> _downloadReport(BuildContext context) async {
  try {
  // Replace with actual user info if available
  final String userName = 'John Doe';
  final String userEmail = 'john.doe@email.com';
  final String date = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  final String overallStatus = 'Engine: 95%\nTransmission: 92%\nBrakes: 88%\nOverall: Excellent';
  
  final pdf = pw.Document();
  pdf.addPage(
  pw.Page(
  build: (pw.Context context) => pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  children: [
  pw.Text('AutoFix Car Health Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
  pw.SizedBox(height: 16),
  pw.Text('User: $userName', style: pw.TextStyle(fontSize: 16)),
  pw.Text('Email: $userEmail', style: pw.TextStyle(fontSize: 16)),
  pw.Text('Date: $date', style: pw.TextStyle(fontSize: 16)),
  pw.SizedBox(height: 24),
  pw.Text('Overall Health Status:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
  pw.SizedBox(height: 8),
  pw.Text(overallStatus, style: pw.TextStyle(fontSize: 16)),
  ],
  ),
  ),
  );
  
  final output = await getApplicationDocumentsDirectory();
  final file = File('${output.path}/autofix_car_health_report.pdf');
  await file.writeAsBytes(await pdf.save());
  
  if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
  content: Text('PDF saved to: ${file.path}'),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  );
  }
  } catch (e) {
  if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
  content: Text('Failed to save PDF: $e'),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  );
  }
  }
  }
}
