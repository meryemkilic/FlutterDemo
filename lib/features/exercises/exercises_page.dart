import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

// ─── Sabitleri tek yerden yönet ───────────────────────────────────────────
const double _strokeW = 88.0; // yol genişliği (referans: kalın yol)
const double _turnR = 68.0; // U-dönüş yarıçapı — daha yumuşak S eğrisi
const double _edgePad = 10.0; // yol dış kenarı ile ekran kenarı arası
const double _bandH = 160.0; // iki U-dönüşü arasındaki düz band yüksekliği
// Satır yüksekliği = üst yarım daire + düz band + alt yarım daire
// Ama painter'da her şey adım adım hesaplanır, rowH sadece kart konumu için:
const double _rowH = _turnR * 2 + _bandH;
const double _topPad = 48.0;
const int _totalRows = 5;

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
    const Color bgColor = Color(0xFFE8F5E8);
    const Color panelColor = Color(0xFFC8E9C4);
    const Color pathColor = Color(0xFF52B87A);
    const Color inactiveColor = Color(0xFFF5FBF4);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildPathHeader(),
          const SizedBox(height: 20),
          _buildFloorTabs(inactiveColor, panelColor, pathColor),
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
                  child: _buildDynamicPath(pathColor, panelColor),
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

  Widget _buildFloorTabs(
    Color inactiveColor,
    Color activeColor,
    Color pathColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTabItem(
            1,
            'HECE',
            _activeFloor == 1,
            activeColor,
            inactiveColor,
          ),
          const SizedBox(width: 4),
          _buildTabItem(
            2,
            'KELİME',
            _activeFloor == 2,
            activeColor,
            inactiveColor,
          ),
          const SizedBox(width: 4),
          _buildTabItem(
            3,
            'CÜMLE',
            _activeFloor == 3,
            activeColor,
            inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    int floor,
    String title,
    bool active,
    Color activeColor,
    Color inactiveColor,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeFloor = floor),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? activeColor : inactiveColor,
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

  Widget _buildDynamicPath(Color roadColor, Color fieldBaseColor) {
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

    final double canvasH = _topPad + _totalRows * _rowH + _turnR + 100.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;

        // Yolun merkez çizgisinin x koordinatları.
        // İç kenar = edgePad, dış kenar = edgePad + strokeW
        // Merkez = edgePad + strokeW/2
        // U-dönüşü merkezi bu x'ten turnR kadar içeride olmalı ki iç kenar
        // tam edgePad'de kalsın.
        // xCenter_left  = edgePad + strokeW/2
        // xCenter_right = w - edgePad - strokeW/2
        final double xL = _edgePad + _strokeW / 2; // sol merkez x
        final double xR = w - _edgePad - _strokeW / 2; // sağ merkez x

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: SizedBox(
            width: w,
            height: canvasH,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(w, canvasH),
                  painter: FieldTexturePainter(
                    baseColor: fieldBaseColor,
                    stripeColor: const Color(0xFF7BC47A).withValues(alpha: 0.22),
                  ),
                ),
                CustomPaint(
                  size: Size(w, canvasH),
                  painter: RoadPainter(
                    roadColor: roadColor,
                    outlineColor: const Color(0xFF2D6B42),
                    xL: xL,
                    xR: xR,
                    turnR: _turnR,
                    bandH: _bandH,
                    topPad: _topPad,
                    totalRows: _totalRows,
                  ),
                ),

                // Kartlar: yolun KENARINDA, düz bandın ortasında
                ...cards.map((c) {
                  final bool ltr = c.row % 2 == 0;

                  // Düz bandın dikey ortası
                  final double bandMidY =
                      _topPad + c.row * _rowH + _turnR + _bandH / 2;

                  // Kartın yatay pozisyonu:
                  // ltr satırda kart sol kenarında (yolun sol iç kenarına yakın)
                  // rtl satırda kart sağ kenarında (yolun sağ iç kenarına yakın)
                  //
                  // Yolun sol iç kenarı = xL - strokeW/2 = edgePad
                  // Yolun sağ iç kenarı = xR + strokeW/2 = w - edgePad
                  //
                  // Kart (110px) yolun dış kenarının dışına taşar — referanstaki gibi
                  final double cardLeft = ltr
                      ? xL -
                            _strokeW / 2 -
                            10 // sol kenara yaslan (biraz dışa taşsın)
                      : xR + _strokeW / 2 - 100; // sağ kenara yaslan

                  return Positioned(
                    left: cardLeft,
                    top: bandMidY - 85,
                    child: _buildExerciseCard(
                      title: c.title,
                      subtitle: c.subtitle,
                      completed: c.completed,
                      current: c.current,
                    ),
                  );
                }),

                // Dekorasyon ikonları — yolun karşı boş tarafında
                ...cards.map((c) {
                  final bool ltr = c.row % 2 == 0;
                  final double bandMidY =
                      _topPad + c.row * _rowH + _turnR + _bandH / 2;
                  // Karşı tarafın ortası (yol içi boşluk yok, ekranın boş alanı)
                  final double iconX = ltr
                      ? xR - _strokeW / 2 + (w - (xR - _strokeW / 2)) * 0.4
                      : xL + _strokeW / 2 - (xL + _strokeW / 2) * 0.4;
                  const icons = [
                    Icons.egg_rounded,
                    Icons.local_florist_rounded,
                    Icons.cloud_rounded,
                    Icons.home_rounded,
                    Icons.forest_rounded,
                  ];
                  return Positioned(
                    left: iconX - 14,
                    top: bandMidY - 14,
                    child: Icon(
                      icons[c.row],
                      size: 28,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseCard({
    required String title,
    required String subtitle,
    required bool completed,
    required bool current,
  }) {
    final Color borderColor = completed
        ? Colors.green.shade700
        : (current ? AppColors.primary : AppColors.secondary);

    return Column(
      children: [
        Container(
          width: 110,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: borderColor, width: 4),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: borderColor.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 44,
                        color: borderColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (completed)
                Positioned(
                  top: -6,
                  right: -6,
                  child: CircleAvatar(
                    backgroundColor: Colors.green.shade700,
                    radius: 13,
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            subtitle,
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.hintText,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Model ────────────────────────────────────────────────────────────────
class _CardData {
  final int row;
  final String title, subtitle;
  final bool completed, current;
  const _CardData({
    required this.row,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.current,
  });
}

// ─── RoadPainter ──────────────────────────────────────────────────────────
//
//  Yol anatomisi — referansa uygun:
//
//  ┌──────────────────────────────────────────────────────┐
//  │  [xL merkez]                         [xR merkez]    │
//  │                                                      │
//  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    ← satır 0 (ltr)
//  │  [kart sol kenarda]                        ╰─╮
//  │                                              │ ← sağ U
//  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    ← satır 1 (rtl)
//  │  ╭─╯                            [kart sağda]
//  │  │ ← sol U
//  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    ← satır 2 (ltr)
//  └──────────────────────────────────────────────────────┘
//
//  xL ve xR: yolun merkez stroke x koordinatları
//  Yol kalınlığı _strokeW → iç kenar ekran kenarına _edgePad kadar uzak
//  U-dönüşü: arcTo ile, merkezi (xL, y+turnR) veya (xR, y+turnR)
//  Dönüş yarıçapı = _turnR (yolun merkez çizgisi üzerinden)
//
class RoadPainter extends CustomPainter {
  static const double _outlineExtra = 12.0;

  final Color roadColor;
  final Color outlineColor;
  final double xL, xR, turnR, bandH, topPad;
  final int totalRows;

  const RoadPainter({
    required this.roadColor,
    required this.outlineColor,
    required this.xL,
    required this.xR,
    required this.turnR,
    required this.bandH,
    required this.topPad,
    required this.totalRows,
  });

  static Path buildCenterPath({
    required double xL,
    required double xR,
    required double turnR,
    required double topPad,
    required int totalRows,
  }) {
    final path = Path();
    double y = topPad + turnR;
    path.moveTo(xL, y);

    for (int row = 0; row < totalRows; row++) {
      final bool ltr = row % 2 == 0;

      if (ltr) {
        path.lineTo(xR, y);
        if (row < totalRows - 1) {
          path.arcTo(
            Rect.fromLTRB(xR - turnR, y, xR + turnR, y + 2 * turnR),
            -math.pi / 2,
            math.pi,
            false,
          );
          y += 2 * turnR;
        }
      } else {
        path.lineTo(xL, y);
        if (row < totalRows - 1) {
          path.arcTo(
            Rect.fromLTRB(xL - turnR, y, xL + turnR, y + 2 * turnR),
            -math.pi / 2,
            -math.pi,
            false,
          );
          y += 2 * turnR;
        }
      }
    }
    return path;
  }

  static void _paintDashedAlongPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashLen,
    double gapLen,
  ) {
    for (final ui.PathMetric metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final double len = math.min(dashLen, metric.length - d);
        canvas.drawPath(metric.extractPath(d, d + len), paint);
        d += dashLen + gapLen;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final centerPath = buildCenterPath(
      xL: xL,
      xR: xR,
      turnR: turnR,
      topPad: topPad,
      totalRows: totalRows,
    );

    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeW + _outlineExtra
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final roadPaint = Paint()
      ..color = roadColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeW
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(centerPath, outlinePaint);
    canvas.drawPath(centerPath, roadPaint);

    final dashPaint = Paint()
      ..color = const Color(0xFFE8FFF0).withValues(alpha: 0.92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    _paintDashedAlongPath(canvas, centerPath, dashPaint, 18, 14);
  }

  @override
  bool shouldRepaint(covariant RoadPainter old) => true;
}

// ─── Çimen dokusu (referans: yatay, hafif koyu yeşil oval şeritler) ───────
class FieldTexturePainter extends CustomPainter {
  final Color baseColor;
  final Color stripeColor;

  FieldTexturePainter({
    required this.baseColor,
    required this.stripeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = baseColor);

    final rnd = math.Random(7);
    const int count = 32;
    for (int i = 0; i < count; i++) {
      final double stripeH = 6 + rnd.nextDouble() * 12;
      final double stripeW = size.width * (0.25 + rnd.nextDouble() * 0.55);
      final double top = rnd.nextDouble() * math.max(1, size.height - stripeH);
      final double left = rnd.nextDouble() * math.max(1, size.width - stripeW);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, stripeW, stripeH),
        Radius.circular(stripeH / 2),
      );
      canvas.drawRRect(rrect, Paint()..color = stripeColor);
    }
  }

  @override
  bool shouldRepaint(covariant FieldTexturePainter old) =>
      old.baseColor != baseColor || old.stripeColor != stripeColor;
}
