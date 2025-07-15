// pages/main_navigation.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'mechanics_page.dart';
import 'engine_diagnosis_page.dart';
import 'dashboard_light_scanning_page.dart';
import 'help_and_support_page.dart';
import 'analysis_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0; // Start with home tab

  final List<Widget> _pages = [
    const HomePage(),
    const MechanicsPage(),
    // const EngineDiagnosisPage(),

    // const DashboardLightScanningPage(),
    const AnalysisPage(),
    const HistoryPage(),
    // const ProfilePage(),
    const HelpAndSupportPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF3182CE),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.build_outlined),
              activeIcon: const Icon(Icons.build),
              label: 'mechanics'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.analytics_outlined),
              activeIcon: const Icon(Icons.analytics),
              label: 'analysis'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_outlined),
              activeIcon: const Icon(Icons.history),
              label: 'history'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.help_outline),
              activeIcon: const Icon(Icons.help),
              label: 'help_support'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
