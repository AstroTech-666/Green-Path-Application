import 'package:flutter/material.dart';
import 'package:green_path/pages/chatbot_page/greenpath_chatbot.dart';
import 'package:provider/provider.dart';
import 'package:green_path/theme_provider.dart';
import 'profile_screen.dart';
import 'pages/carbon_footprint_page/carbon_footprint_screen.dart';
import 'pages/eco_friendly_ product_page/eco_friendly_product_finder.dart';
import 'pages/energy_tracker_page/main_energy_tracker.dart';
import 'pages/personal_goals_page/personal_goals_screen.dart';
import 'pages/waste_management_page/waste_management_guide.dart';
import 'pages/water_tracker_page/water_tracker.dart';
import 'pages/greenpath_academy/greenpath_academy.dart';
import 'pages/air_quality_page/air_protection_screen.dart';
import 'pages/quizzes_page/quizzes_page.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  _FeatureScreenState createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco),
            SizedBox(width: 8),
            Text('Features'),
          ],
        ),
        backgroundColor: Colors.green[700],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                size: 40.0, // Increased size for better visibility
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.account_circle,
                size: 40.0, // Increased size for better visibility
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // 1 card per row
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 3, // Adjusted for more vertical space
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return SolidCard(
                      text: _getCardText(index),
                      imagePath: _getCardImage(index),
                      onPressed: () => _navigateToScreen(context, index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          color: Colors.white, // Adds a notch for the FloatingActionButton
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              _bottomNavItem(context, Icons.search, 'Product Finder',
                  const ProductFinderScreen()),
              _bottomNavItem(context, Icons.smart_toy, 'GreenPath Helper',
                  const ChatBotPage()),
              _bottomNavItem(context, Icons.menu_book, 'GreenPath Academy',
                  const GreenPathAcademyPage()),
              _bottomNavItem(context, Icons.flag, 'Personal Goals',
                  const PersonalGoalsScreen()),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to handle navigation
  void _navigateToScreen(BuildContext context, int index) {
    final screens = [
      const CarbonFootprintScreen(),
      const MainEnergyScreen(),
      const WaterTrackerScreen(),
      const WasteManagementGuideScreen(),
      const QuizScreen(),
      const AirProtectionScreen(),
    ];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screens[index]),
    );
  }

  // Helper function to return the text for each card
  String _getCardText(int index) {
    const texts = [
      'Carbon Footprint Calculator',
      'Energy Consumption Tracker',
      'Water Usage Tracker',
      'Waste Management Guide',
      'Green Quiz',
      'Air Quality Protection'
    ];
    return texts[index];
  }

  // Helper function to return the image path for each card
  String _getCardImage(int index) {
    const images = [
      'assets/icons/carbon_footprint_icon.png',
      'assets/icons/energy_tracker_icon.png',
      'assets/icons/water_usage_icon.png',
      'assets/icons/waste_management_icon.png',
      'assets/icons/quiz_icon.png',
      'assets/icons/air_quality_icon.png'
    ];
    return images[index];
  }

  Widget _bottomNavItem(
      BuildContext context, IconData icon, String label, Widget? screen) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              icon,
              size: 24.0,
              color: const Color.fromARGB(255, 1, 56, 1), // Dark green color
            ),
            onPressed: () {
              if (screen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              }
            },
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black, // Black color for text
            ),
          ),
        ],
      ),
    );
  }
}

class SolidCard extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onPressed;

  const SolidCard({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black54, Colors.grey]
                : [Colors.green, Colors.green[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(4, 6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                width: 85,
                height: 80,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
