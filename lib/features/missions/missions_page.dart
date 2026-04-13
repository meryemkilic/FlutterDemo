import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  int _activeTab = 0; // 0 for "Bekleyen", 1 for "Tamamlanan"

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        _buildHeader(),
        const SizedBox(height: 24),
        _buildTabs(),
        Expanded(
          child: _activeTab == 0 ? _buildPendingMissions() : _buildCompletedMissions(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 80),
          Text(
            'GÖREVLER',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 1.2,
            ),
          ),
          _buildCoinCounter(),
        ],
      ),
    );
  }

  Widget _buildCoinCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.diamond_rounded, color: AppColors.yellow, size: 20),
          const SizedBox(width: 6),
          Text(
            '300',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E9F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildTabItem(0, 'Bekleyen'),
          _buildTabItem(1, 'Tamamlanan'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isActive ? AppColors.primary : AppColors.hintText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingMissions() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
      children: [
        _buildAssignmentCard(
          letter: 'K',
          levelTitle: 'Hece Düzeyi',
          exercise: '1. Egzersiz',
          iconColor: Colors.deepPurpleAccent,
          current: 0,
          total: 10,
          gameLevel: 1,
        ),
        _buildAssignmentCard(
          letter: 'R',
          levelTitle: 'Kelime Düzeyi',
          exercise: '3. Egzersiz',
          iconColor: Colors.blueAccent,
          current: 3,
          total: 5,
          gameLevel: 2,
        ),
        _buildAssignmentCard(
          letter: 'S',
          levelTitle: 'Cümle Düzeyi',
          exercise: '2. Egzersiz',
          iconColor: Colors.orangeAccent,
          current: 0,
          total: 1,
          gameLevel: 3,
        ),
      ],
    );
  }

  Widget _buildCompletedMissions() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
      children: [
        _buildAssignmentCard(
          letter: 'B',
          levelTitle: 'Hece Düzeyi',
          exercise: '10. Egzersiz',
          iconColor: Colors.green,
          current: 5,
          total: 5,
          gameLevel: 1,
          isCompleted: true,
        ),
      ],
    );
  }

  Widget _buildAssignmentCard({
    required String letter,
    required String levelTitle,
    required String exercise,
    required Color iconColor,
    required int current,
    required int total,
    required int gameLevel,
    bool isCompleted = false,
  }) {
    double progress = current / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Letter Circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: iconColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Assignment Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$gameLevel. OYUN',
                              style: GoogleFonts.quicksand(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.bolt, size: 12, color: AppColors.yellow),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$levelTitle - $exercise',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Modern Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFF0F0F0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? Colors.green : AppColors.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'İlerleme: $current / $total',
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hintText,
                  ),
                ),
                ElevatedButton(
                  onPressed: isCompleted ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isCompleted ? 'TAMAMLANDI' : 'GÖREVE BAŞLA',
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (!isCompleted) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.play_arrow_rounded, size: 16),
                      ]
                    ],
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
