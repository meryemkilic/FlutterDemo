import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

const double _strokeW = 56.0;
const double _edgePad = 26.0;
const double _topPad = 56.0;

const double _cardW = 130.0;
const double _cardH = 155.0;
const double _labelH = 30.0;

const int _nRows = 5;
const double _rowGap = 210.0;

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  String? _selectedLetter;
  int _activeFloor = 1;

  final List<String> consonants = [
    'B',
    'C',
    'Ç',
    'D',
    'F',
    'G',
    'Ğ',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'R',
    'S',
    'Ş',
    'T',
    'V',
    'Y',
    'Z',
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedLetter == null) return _buildLetterSelector();
    return _buildPathView();
  }

  Widget _buildLetterSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Çalışmak İstediğin\nHarfi Seç 🎯',
            style: GoogleFonts.quicksand(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: consonants.length,
              itemBuilder: (_, i) => _buildLetterCard(consonants[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterCard(String letter) {
    return GestureDetector(
      onTap: () => setState(() => _selectedLetter = letter),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: GoogleFonts.quicksand(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildPathView() {
    const Color bgColor = Color(0xFFEDF8ED);
    const Color panelColor = Color(0xFFCEECCB);
    const Color pathColor = Color(0xFF67CAA1);
    const Color tabOff = Color(0xFFFAFDF9);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildPathHeader(),
          const SizedBox(height: 20),
          _buildFloorTabs(tabOff, panelColor, pathColor),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -1),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(36),
                  ),
                  child: _buildScrollContent(pathColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPathHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
              size: 20,
            ),
            onPressed: () => setState(() => _selectedLetter = null),
          ),
          const SizedBox(width: 4),
          Text(
            '$_selectedLetter HARFİ',
            style: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.yellow, size: 20),
                const SizedBox(width: 4),
                Text(
                  '12/12',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorTabs(Color off, Color on, Color path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _tab(1, 'HECE', on, off),
          const SizedBox(width: 4),
          _tab(2, 'KELİME', on, off),
          const SizedBox(width: 4),
          _tab(3, 'CÜMLE', on, off),
        ],
      ),
    );
  }

  Widget _tab(int floor, String title, Color on, Color off) {
    final bool active = _activeFloor == floor;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeFloor = floor),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? on : off,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: active
                ? null
                : Border.all(color: Colors.black.withValues(alpha: 0.02)),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w900,
              color: active ? AppColors.primary : AppColors.hintText,
              fontSize: 11,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollContent(Color roadColor) {
    final cards = [
      _CardData(
        row: 0,
        title: 'Bahar Esintisi',
        subtitle: '1. Egzersiz',
        completed: true,
        current: true,
      ),
      _CardData(
        row: 1,
        title: 'Yaz Tatili',
        subtitle: '2. Egzersiz',
        completed: true,
        current: false,
      ),
      _CardData(
        row: 2,
        title: 'Yağmurlu Gün',
        subtitle: '3. Egzersiz',
        completed: false,
        current: true,
      ),
      _CardData(
        row: 3,
        title: 'Kış Uykusu',
        subtitle: '4. Egzersiz',
        completed: false,
        current: false,
      ),
      _CardData(
        row: 4,
        title: 'Çiftlikte Yaşam',
        subtitle: '5. Egzersiz',
        completed: false,
        current: false,
      ),
    ];

    final decorations = [
      const _DecorationData(
        asset: 'assets/illustrations/nature/tree_pair.png',
        width: 82,
        topOffset: -30,
        placeLeft: false,
      ),
      const _DecorationData(
        asset: 'assets/illustrations/nature/pond_ducks.png',
        width: 88,
        topOffset: 18,
        placeLeft: true,
      ),
      const _DecorationData(
        asset: 'assets/illustrations/nature/bush_flowers.png',
        width: 64,
        topOffset: 10,
        placeLeft: false,
      ),
      const _DecorationData(
        asset: 'assets/illustrations/nature/cottage.png',
        width: 92,
        topOffset: -20,
        placeLeft: true,
      ),
      const _DecorationData(
        asset: 'assets/illustrations/nature/windmill.png',
        width: 86,
        topOffset: 0,
        placeLeft: false,
      ),
    ];

    return LayoutBuilder(
      builder: (context, box) {
        final double w = box.maxWidth;

        final double xLeft = _edgePad + _strokeW / 2;
        final double xRight = w - _edgePad - _strokeW / 2;
        final double centerX = w / 2;

        final double canvasH = _topPad + (_nRows * _rowGap) + 180;

        double rowY(int row) => _topPad + row * _rowGap + 70;

        double cardCenterX(int row) {
          final bool leftSide = row.isEven;
          return leftSide
              ? xLeft + (centerX - xLeft) * 0.42
              : xRight - (xRight - centerX) * 0.42;
        }

        double decoCenterX(int row, bool placeLeft) {
          if (placeLeft) {
            return xLeft + (centerX - xLeft) * 0.18;
          } else {
            return xRight - (xRight - centerX) * 0.18;
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: SizedBox(
            width: w,
            height: canvasH,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(w, canvasH),
                  painter: _RoadPainter(
                    roadColor: roadColor,
                    xLeft: xLeft,
                    xRight: xRight,
                    topPad: _topPad,
                    rowGap: _rowGap,
                    rowCount: _nRows,
                  ),
                ),

                ...List.generate(decorations.length, (i) {
                  final d = decorations[i];
                  final y = rowY(i) + d.topOffset;
                  final x = decoCenterX(i, d.placeLeft);

                  return Positioned(
                    left: x - d.width / 2,
                    top: y,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.95,
                        child: Image.asset(
                          d.asset,
                          width: d.width,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }),

                ...cards.map((c) {
                  final double y = rowY(c.row);
                  final double x = cardCenterX(c.row);

                  return Positioned(
                    left: x - _cardW / 2,
                    top: y - (_cardH + _labelH) / 2,
                    child: _buildCard(c),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(_CardData c) {
    final Color border = c.completed
        ? Colors.green.shade700
        : (c.current ? AppColors.primary : AppColors.secondary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _cardW,
          height: _cardH,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
            border: Border.all(color: border, width: 4),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: border.withValues(alpha: 0.06),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 52,
                        color: border,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(18),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        c.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (c.completed)
                Positioned(
                  top: -6,
                  right: -6,
                  child: CircleAvatar(
                    backgroundColor: Colors.green.shade700,
                    radius: 14,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            c.subtitle,
            style: GoogleFonts.quicksand(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.hintText,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardData {
  final int row;
  final String title;
  final String subtitle;
  final bool completed;
  final bool current;

  const _CardData({
    required this.row,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.current,
  });
}

class _DecorationData {
  final String asset;
  final double width;
  final double topOffset;
  final bool placeLeft;

  const _DecorationData({
    required this.asset,
    required this.width,
    required this.topOffset,
    required this.placeLeft,
  });
}

class _RoadPainter extends CustomPainter {
  final Color roadColor;
  final double xLeft;
  final double xRight;
  final double topPad;
  final double rowGap;
  final int rowCount;

  const _RoadPainter({
    required this.roadColor,
    required this.xLeft,
    required this.xRight,
    required this.topPad,
    required this.rowGap,
    required this.rowCount,
  });

  double _rowY(int row) => topPad + row * rowGap + 70;

  Path _buildRoadPath() {
    final path = Path();

    final double startY = _rowY(0);
    path.moveTo(xLeft, startY);

    for (int row = 0; row < rowCount; row++) {
      final bool leftToRight = row.isEven;
      final double y = _rowY(row);

      if (leftToRight) {
        path.lineTo(xRight, y);
      } else {
        path.lineTo(xLeft, y);
      }

      if (row < rowCount - 1) {
        final double nextY = _rowY(row + 1);
        final double midY = (y + nextY) / 2;

        if (leftToRight) {
          path.quadraticBezierTo(xRight, midY, (xLeft + xRight) / 2, midY);
          path.quadraticBezierTo(xLeft, midY, xLeft, nextY);
        } else {
          path.quadraticBezierTo(xLeft, midY, (xLeft + xRight) / 2, midY);
          path.quadraticBezierTo(xRight, midY, xRight, nextY);
        }
      }
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final roadPath = _buildRoadPath();

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeW + 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final roadPaint = Paint()
      ..color = roadColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeW
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final innerGlowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeW - 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(roadPath, shadowPaint);
    canvas.drawPath(roadPath, roadPaint);
    canvas.drawPath(roadPath, innerGlowPaint);

    _drawDashedCenterLine(canvas, roadPath);
  }

  void _drawDashedCenterLine(Canvas canvas, Path path) {
    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.62)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    const double dashLength = 18;
    const double dashGap = 13;

    for (final metric in path.computeMetrics()) {
      double distance = 10;

      while (distance < metric.length) {
        final double end = (distance + dashLength < metric.length)
            ? distance + dashLength
            : metric.length;

        final extracted = metric.extractPath(distance, end);
        canvas.drawPath(extracted, dashPaint);

        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) {
    return oldDelegate.roadColor != roadColor ||
        oldDelegate.xLeft != xLeft ||
        oldDelegate.xRight != xRight ||
        oldDelegate.topPad != topPad ||
        oldDelegate.rowGap != rowGap ||
        oldDelegate.rowCount != rowCount;
  }
}
