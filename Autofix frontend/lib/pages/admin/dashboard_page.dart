// import 'package:autofix_car/services/user_service.dart';
// import 'package:autofix_car/models/user_profile.dart';
// import 'package:autofix_car/widgets/custom_card.dart';
// import 'package:flutter/material.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Admin Dashboard',
//             style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueGrey,
//             ),
//           ),
//           const SizedBox(height: 24),
//           GridView.count(
//             crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : 1,
//             crossAxisSpacing: 24,
//             mainAxisSpacing: 24,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               StreamBuilder<List<UserProfile>>(
//                 stream: UserService.getUsers(),
//                 builder: (context, snapshot) {
//                   final userCount = snapshot.data?.length ?? 0;
//                   return CustomCard(
//                     backgroundColor: Colors.indigo.shade600,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.indigo.shade200,
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.people_alt,
//                           size: 60,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Total Users',
//                           style: TextStyle(fontSize: 20, color: Colors.white70),
//                         ),
//                         Text(
//                           '$userCount',
//                           style: const TextStyle(
//                             fontSize: 48,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               StreamBuilder<List<UserMessageModel>>(
//                 stream: firestoreService.getUserMessages(),
//                 builder: (context, snapshot) {
//                   final messageCount = snapshot.data?.length ?? 0;
//                   return CustomCard(
//                     backgroundColor: Colors.green.shade600,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.green.shade200,
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.message,
//                           size: 60,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'New Messages',
//                           style: TextStyle(fontSize: 20, color: Colors.white70),
//                         ),
//                         Text(
//                           '$messageCount',
//                           style: const TextStyle(
//                             fontSize: 48,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               StreamBuilder<List<ActivityLogModel>>(
//                 stream: firestoreService.getActivityLogs(),
//                 builder: (context, snapshot) {
//                   final activityCount = snapshot.data?.length ?? 0;
//                   return CustomCard(
//                     backgroundColor: Colors.orange.shade600,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.orange.shade200,
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.history,
//                           size: 60,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Recent Activities',
//                           style: TextStyle(fontSize: 20, color: Colors.white70),
//                         ),
//                         Text(
//                           '$activityCount',
//                           style: const TextStyle(
//                             fontSize: 48,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 32),
//           CustomCard(
//             title: 'Quick Actions',
//             child: Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: [
//                 CustomButton(
//                   onPressed: () {
//                     // Navigate to Notifications
//                     Provider.of<AppState>(
//                       context,
//                       listen: false,
//                     ).setCurrentPage(AppPage.notifications);
//                   },
//                   text: 'Send Notification',
//                   icon: Icons.notifications,
//                 ),
//                 CustomButton(
//                   onPressed: () {
//                     // Navigate to FAQs
//                     Provider.of<AppState>(
//                       context,
//                       listen: false,
//                     ).setCurrentPage(AppPage.faqs);
//                   },
//                   text: 'Add New FAQ',
//                   icon: Icons.add_circle,
//                   backgroundColor: Colors.teal,
//                 ),
//                 CustomButton(
//                   onPressed: () {
//                     // Navigate to User Management
//                     Provider.of<AppState>(
//                       context,
//                       listen: false,
//                     ).setCurrentPage(AppPage.users);
//                   },
//                   text: 'Manage Users',
//                   icon: Icons.group,
//                   backgroundColor: Colors.blueGrey,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
