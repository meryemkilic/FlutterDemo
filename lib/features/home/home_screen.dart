import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../missions/missions_page.dart';
import '../profile/profile_page.dart';
import '../exercises/exercises_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Soft light background
      extendBody: true, // Allow body to expand behind the floating bottom bar
      body: _buildPage(),
      bottomNavigationBar: _buildFloatingBottomBar(),
    );
  }

  Widget _buildPage() {
    // Current page content
    return IndexedStack(
      index: _selectedIndex,
      children: [
        const ExercisesPage(),
        const MissionsPage(),
        _buildSimplePage('Başarılar'),
        _buildSimplePage('Mağaza'),
        const ProfilePage(),
      ],
    );
  }

  Widget _buildSimplePage(String title) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 24,
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar() {
    return SafeArea(
      child: Container(
        height: 72,
        margin: const EdgeInsets.fromLTRB(28, 0, 28, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.menu_book_rounded),
            _buildNavItem(1, Icons.assignment_rounded), // Representing clipboard
            _buildNavItem(2, Icons.emoji_events_rounded),
            _buildNavItem(3, Icons.store_rounded),
            _buildNavItem(4, Icons.person_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.secondary;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Specialized active icons (adding yellow details like Duolingo)
            if (isSelected) 
              _buildActiveIcon(index, icon)
            else
              Icon(
                icon,
                size: 28,
                color: AppColors.hintText.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveIcon(int index, IconData icon) {
    // Adding small characteristic details to selected icons to match the reference
    switch (index) {
      case 1: // Tasks (Clipboard with yellow check)
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            Positioned(
              bottom: 4,
              right: 4,
              child: Icon(Icons.check_circle, size: 14, color: AppColors.yellow),
            ),
          ],
        );
      case 4: // Profile (Person with yellow detail)
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      default:
        return Icon(icon, size: 32, color: AppColors.primary);
    }
  }
}
