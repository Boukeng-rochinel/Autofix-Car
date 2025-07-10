// lib/screens/home_page.dart
import 'package:autofix_car/pages/dashboard_light_scanning_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome, though not directly used in HomePage's build method, it's good practice for screens
import 'package:google_fonts/google_fonts.dart'; // For Inter font, if specific styles within HomePage use it

import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
// import '../widgets/bottom_nav_bar.dart';
import '../widgets/camera_overlay_scanner.dart';
import '../pages/engine_diagnosis_page.dart';
import '../pages/profile_page.dart';
import 'help_and_support_page.dart'; // Ensure this is imported if used in bottom nav or elsewhere
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

  // If userId is null, notifications are for everyone
  String? get _userId => _userProfile?.id; // or null for global

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
      final notifications = await NotificationService.getMyNotifications(_userId ?? '');
      setState(() {
        _notifications = notifications;
        _isLoadingNotifications = false;
      });
    } catch (e) {
      setState(() {
        _notificationError = e.toString();
        _isLoadingNotifications = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                'Loading...',
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
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.only(
          top: 60.0,
          left: 24.0,
          right: 24.0,
          bottom: 20.0,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Container(
        padding: const EdgeInsets.only(
          top: 60.0,
          left: 24.0,
          right: 24.0,
          bottom: 20.0,
        ),
        child: Center(
          child: Text('Error: $_error', style: TextStyle(color: Colors.red)),
        ),
      );
    }
    final user = _userProfile;
    return Container(
    padding: const EdgeInsets.only(
    top: 60.0,
    left: 24.0,
    right: 24.0,
    bottom: 20.0,
    ),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [AppColors.lightBlueGradientStart, AppColors.blueGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(30.0),
    bottomRight: Radius.circular(30.0),
    ),
    ),
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
    'Welcome!',
    style: AppStyles.headline1.copyWith(color: Colors.white),
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
    'Car: ${user!.carModel}',
    style: AppStyles.bodyText.copyWith(color: Colors.white70),
    ),
    if ((user?.userLocation ?? '').isNotEmpty)
    Text(
    'Location: ${user!.userLocation}',
    style: AppStyles.bodyText.copyWith(color: Colors.white70),
    ),
    if ((user?.contact ?? '').isNotEmpty)
    Text(
    'Contact: ${user!.contact}',
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
    child: user?.imageUrl != null && user!.imageUrl!.isNotEmpty
    ? CircleAvatar(
    radius: 30,
    backgroundColor: Colors.white,
    backgroundImage: NetworkImage(user.imageUrl!),
    onBackgroundImageError: (exception, stackTrace) {
    print('Error loading profile picture: $exception');
    },
    )
    : CircleAvatar(
    radius: 30,
    backgroundColor: Colors.white,
    child: Text(
    (user?.name ?? user?.email ?? 'U').isNotEmpty
    ? (user?.name ?? user?.email ?? 'U')[0].toUpperCase()
    : 'U',
    style: const TextStyle(
    fontSize: 28,
    color: Colors.black54,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    ],
    ),
    
    // const SizedBox(height: 30),
    ],
    ),
    );
    }

  Widget _buildVehicleCategories() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Categories',
            style: AppStyles.headline2.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryItem(Icons.motorcycle, 'Bike'),
              _buildCategoryItem(Icons.directions_car, 'Car'),
              _buildCategoryItem(Icons.directions_bus, 'Bus'),
              _buildCategoryItem(Icons.airport_shuttle, 'Van'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Add category selection logic here
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark.withOpacity(0.1),
                  AppColors.primaryDark.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: AppColors.primaryDark.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 25, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppStyles.bodyText.copyWith(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisCards(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Diagnosis Tools',
            style: AppStyles.headline2.copyWith(
              color: AppColors.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDiagnosisCard(
            context,
            'Engine Sound Diagnosis',
            'AI powered engine sound analysis',
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
            'Dashboard Light Scanning',
            'AI powered dashboard light analysis',
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.headline3.copyWith(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.greyTextColor,
                      fontSize: AppStyles.bodyText2.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(Icons.arrow_forward_ios, color: color, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    if (_isLoadingNotifications) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_notificationError != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Error: $_notificationError',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Limit notifications to maximum 3
    final displayNotifications = _notifications.take(3).toList();
    final hasMoreNotifications = _notifications.length > 3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Notifications',
                style: AppStyles.headline2.copyWith(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hasMoreNotifications)
                GestureDetector(
                  onTap: () {
                    _showAllNotifications();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      'View All',
                      style: AppStyles.bodyText.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _notifications.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        color: AppColors.greyTextColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'No notifications yet',
                        style: AppStyles.bodyText.copyWith(
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...displayNotifications.map((notification) {
                        return Row(
                          children: [
                            _buildNotificationCard(
                              notification,
                            ),
                            const SizedBox(width: 15),
                          ],
                        );
                      }).toList(),
                      if (hasMoreNotifications) _buildMoreNotificationsCard(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void _showAllNotifications() {
  showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
  height: MediaQuery.of(context).size.height * 0.8,
  decoration: const BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  child: Column(
  children: [
  Container(
  padding: const EdgeInsets.all(20.0),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  'All Notifications',
  style: AppStyles.headline2.copyWith(
  color: AppColors.textColor,
  fontWeight: FontWeight.w600,
  ),
  ),
  IconButton(
  onPressed: () => Navigator.pop(context),
  icon: const Icon(Icons.close),
  ),
  ],
  ),
  ),
  Expanded(
  child: ListView.builder(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  itemCount: _notifications.length,
  itemBuilder: (context, index) {
  final notification = _notifications[index];
  IconData icon;
  Color iconColor = AppColors.primaryColor;
  if (notification.title.toLowerCase().contains('call')) {
  icon = Icons.call;
  iconColor = Colors.green;
  } else if (notification.title.toLowerCase().contains('message')) {
  icon = Icons.message;
  iconColor = Colors.blue;
  } else {
  icon = Icons.notifications_active;
  iconColor = AppColors.primaryColor;
  }
  return Container(
  margin: const EdgeInsets.only(bottom: 12.0),
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
  color: AppColors.lightGrey.withOpacity(0.3),
  borderRadius: BorderRadius.circular(12.0),
  ),
  child: Row(
  children: [
  Container(
  width: 50,
  height: 50,
  decoration: BoxDecoration(
  color: iconColor.withOpacity(0.1),
  borderRadius: BorderRadius.circular(8.0),
  ),
  child: Icon(icon, color: iconColor, size: 32),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  notification.title,
  style: AppStyles.headline3.copyWith(
  color: AppColors.textColor,
  fontWeight: FontWeight.w600,
  ),
  ),
  const SizedBox(height: 4),
  Text(
  notification.message,
  style: AppStyles.bodyText.copyWith(
  color: AppColors.greyTextColor,
  ),
  ),
  ],
  ),
  ),
  ],
  ),
  );
  },
  ),
  ),
  ],
  ),
  ),
  );
  }

  Widget _buildMoreNotificationsCard() {
    final remainingCount = _notifications.length - 3;
    return GestureDetector(
      onTap: _showAllNotifications,
      child: Container(
        width: 180,
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              AppColors.primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(Icons.add, size: 32, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 12),
            Text(
              '+$remainingCount More',
              style: AppStyles.headline3.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'View all notifications',
              style: AppStyles.bodyText.copyWith(
                color: AppColors.greyTextColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    IconData icon;
    Color iconColor = AppColors.primaryColor;
    if (notification.title.toLowerCase().contains('call')) {
      icon = Icons.call;
      iconColor = Colors.green;
    } else if (notification.title.toLowerCase().contains('message')) {
      icon = Icons.message;
      iconColor = Colors.blue;
    } else {
      icon = Icons.notifications_active;
      iconColor = AppColors.primaryColor;
    }
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.lightGrey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.1),
                  iconColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 48,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppStyles.headline3.copyWith(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  notification.message,
                  style: AppStyles.bodyText.copyWith(
                    color: AppColors.greyTextColor,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'New',
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
