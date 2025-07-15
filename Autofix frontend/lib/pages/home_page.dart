// lib/screens/home_page.dart
import 'package:autofix_car/pages/dashboard_light_scanning_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../widgets/camera_overlay_scanner.dart';
import '../pages/engine_diagnosis_page.dart';
import '../pages/profile_page.dart';
import 'help_and_support_page.dart';
import 'package:autofix_car/services/user_service.dart';
import 'package:autofix_car/models/user_profile.dart';
import 'package:autofix_car/services/notification_service.dart';
import 'package:autofix_car/models/notification_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _error;
  List<NotificationItem> _notifications = [];
  bool _isLoadingNotifications = true;
  String? _notificationError;

  String? get _userId => _userProfile?.id;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchNotifications();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profile = await UserService.getUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoadingNotifications = true;
      _notificationError = null;
    });
    try {
      _notifications = await NotificationService.getMyNotifications(_userId ?? '');
      setState(() {
        _isLoadingNotifications = false;
      });
    } catch (e) {
      setState(() {
        _notificationError = e.toString();
        _isLoadingNotifications = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'loading'.tr(),
                style: AppStyles.bodyText1.copyWith(
                  color: AppColors.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildVehicleCategories(),
            _buildDiagnosisCards(context),
            _buildNotificationsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = _userProfile;
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A5F),
            Color(0xFF3182CE),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'welcome_back'.tr(),
                        style: AppStyles.bodyText.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (user?.name ?? '').isNotEmpty
                            ? user!.name!
                            : (user?.email ?? ''),
                        style: AppStyles.bodyText.copyWith(color: Colors.white70),
                      ),
                      if ((user?.carModel ?? '').isNotEmpty)
                        Text(
                          '${'car'.tr()}: ${user!.carModel}',
                          style: AppStyles.bodyText.copyWith(color: Colors.white70),
                        ),
                      if ((user?.userLocation ?? '').isNotEmpty)
                        Text(
                          '${'location'.tr()}: ${user!.userLocation}',
                          style: AppStyles.bodyText.copyWith(color: Colors.white70),
                        ),
                      if ((user?.contact ?? '').isNotEmpty)
                        Text(
                          '${'contact'.tr()}: ${user!.contact}',
                          style: AppStyles.bodyText.copyWith(color: Colors.white70),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCategories() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'vehicle_categories'.tr(),
            style: AppStyles.headline2.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryItem(Icons.motorcycle, 'bike'.tr()),
              _buildCategoryItem(Icons.directions_car, 'car'.tr()),
              _buildCategoryItem(Icons.directions_bus, 'bus'.tr()),
              _buildCategoryItem(Icons.airport_shuttle, 'van'.tr()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppStyles.bodyText2.copyWith(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosisCards(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ai_diagnosis_tools'.tr(),
            style: AppStyles.headline2.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDiagnosisCard(
            context,
            'engine_sound_diagnosis'.tr(),
            'ai_powered_engine_analysis'.tr(),
            const Color.fromARGB(255, 58, 169, 248),
            Icons.graphic_eq,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EngineDiagnosisPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildDiagnosisCard(
            context,
            'dashboard_light_scanning'.tr(),
            'ai_powered_dashboard_analysis'.tr(),
            const Color.fromARGB(255, 248, 155, 145),
            Icons.lightbulb_outline,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardLightScanningPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.headline3.copyWith(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppStyles.bodyText2.copyWith(
                      color: AppColors.greyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'recent_notifications'.tr(),
            style: AppStyles.headline2.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _isLoadingNotifications
              ? const Center(child: CircularProgressIndicator())
              : _notifications.isEmpty
                  ? Text(
                      'no_notifications'.tr(),
                      style: AppStyles.bodyText2.copyWith(
                        color: AppColors.greyTextColor,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _notifications.take(3).length,
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.title,
                                      style: AppStyles.bodyText1.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      notification.message,
                                      style: AppStyles.bodyText2.copyWith(
                                        color: AppColors.greyTextColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
