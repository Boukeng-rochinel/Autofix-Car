// pages/login_page.dart (Landing Page)
import 'package:flutter/material.dart';
import '../widgets/dashboard_header_copy.dart';
import 'register_page.dart';
import 'welcome_page.dart';
// import 'package:easy_localization/easy_localization.dart'; // Removed

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void _handleNext() {
    // Navigate to main app with navbar
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // Dashboard Header
            const DashboardHeader(),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),

                      // Title
                      Center(
                        child: Text(
                          'Choose your preferred language to continue', // Hardcoded
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // English
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            // await context.setLocale(const Locale('en')); // Removed
                            _handleNext();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3182CE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            // Hardcoded
                            'English',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // French
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            // await context.setLocale(const Locale('fr')); // Removed
                            _handleNext();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3182CE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            // Hardcoded
                            'French',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      const SizedBox(height: 20),

                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
