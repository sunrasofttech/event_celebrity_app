import 'package:flutter/material.dart';
import 'package:planner_celebrity/UI/Auth/WelcomeScreen.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "asset/icons/onboard.png",
      "title": "Discover Music",
      "description": "Find the best tracks from your favorite artists.",
    },
    {
      "image": "asset/icons/onboard.png",
      "title": "Create Playlists",
      "description": "Build and customize playlists that match your vibe.",
    },
    {
      "image": "asset/icons/onboard.png",
      "title": "Enjoy Everywhere",
      "description": "Listen anytime, anywhere — even offline. Listen anytime, anywhere — even offline.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for swiping image + text
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final item = onboardingData[index];
                return _buildPage(imagePath: item["image"]!, title: item["title"]!, description: item["description"]!);
              },
            ),
          ),

          // Skip button stays static
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => WelcomeScreen()), (c) => false);
              },
              child: const Text('Skip', style: TextStyle(color: greyColor, fontSize: 16)),
            ),
          ),

          // Bottom content (static style, only content changes)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _container(
              title: onboardingData[_currentPage]["title"]!,
              description: onboardingData[_currentPage]["description"]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _container({required String title, required String description}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildDot(index == _currentPage),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Description
            Text(description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String imagePath, required String title, required String description}) {
    return Image.asset(imagePath, fit: BoxFit.cover);
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
