import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../home/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _registerFullNameController = TextEditingController();
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerBirthDateController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  bool _loginPasswordVisible = false;
  bool _registerPasswordVisible = false;
  bool _registerConfirmPasswordVisible = false;
  bool _kvkkAccepted = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _registerBirthDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerFullNameController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerBirthDateController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  bool get isSignIn => _tabController.index == 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // ── Mor üst bölüm: maskot + konuşma balonu ──
          _buildHeader(screenHeight),

          // ── Tab çubuğu (tablar mor-beyaz sınırında) ──
          _buildTabRow(),

          // ── Beyaz kart: form alanı ──
          Expanded(child: _buildWhiteCard()),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // MOR ÜST BÖLÜM
  // ─────────────────────────────────────────────────
  Widget _buildHeader(double screenHeight) {
    return Container(
      height: screenHeight * 0.30,
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Dekoratif daireler (arka plan)
            Positioned(
              right: -30,
              top: -20,
              child: _circle(
                140,
                AppColors.primaryLight.withValues(alpha: 0.35),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -30,
              child: _circle(
                120,
                AppColors.primaryLight.withValues(alpha: 0.2),
              ),
            ),

            // İçerik: maskot + konuşma balonu
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Maskot placeholder
                  _buildMascotPlaceholder(),
                  const SizedBox(width: 16),

                  // Konuşma balonu
                  Flexible(child: _buildSpeechBubble()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMascotPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondary,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.4),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.face_rounded, size: 56, color: AppColors.primary),
    );
  }

  Widget _buildSpeechBubble() {
    final text = isSignIn ? 'Hoş geldin!' : 'Haydi\nBaşlayalım!';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.quicksand(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 17,
              height: 1.3,
            ),
          ),
        ),
        // Küçük balonun kuyruğu
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CustomPaint(
            size: const Size(12, 8),
            painter: _BubbleTailPainter(),
          ),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  // ─────────────────────────────────────────────────
  // TAB SATIRI
  // ─────────────────────────────────────────────────
  Widget _buildTabRow() {
    return Container(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: _buildTabButton('GİRİŞ YAP', 0)),
            const SizedBox(width: 4), // tiny gap between folder tabs
            Expanded(child: _buildTabButton('KAYIT OL', 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final selected = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.white : AppColors.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: selected ? AppColors.primary : AppColors.hintText,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // BEYAZ KART
  // ─────────────────────────────────────────────────
  Widget _buildWhiteCard() {
    return Transform.translate(
      offset: const Offset(0, -2),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            // GİRİŞ YAP FORMU
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(52, 8, 52, 28),
              child: _buildLoginForm(key: const ValueKey('login')),
            ),
            // KAYIT OL FORMU
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(52, 8, 52, 28),
              child: _buildRegisterForm(key: const ValueKey('register')),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // GİRİŞ FORMU
  // ─────────────────────────────────────────────────
  Widget _buildLoginForm({Key? key}) {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          _buildTextField(
            controller: _loginEmailController,
            hint: 'Kullanıcı Adı',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _loginPasswordController,
            hint: 'Şifre',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: _loginPasswordVisible,
            onToggleVisibility: () =>
                setState(() => _loginPasswordVisible = !_loginPasswordVisible),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Şifremi Unuttum?',
                style: GoogleFonts.quicksand(
                  color: AppColors.hintText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildYellowButton(
            label: 'GİRİŞ YAP',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildSocialRow(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // KAYIT FORMU
  // ─────────────────────────────────────────────────
  Widget _buildRegisterForm({Key? key}) {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          _buildTextField(
            controller: _registerFullNameController,
            hint: 'Ad Soyad',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _registerNameController,
            hint: 'Kullanıcı Adı',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _registerEmailController,
            hint: 'E-posta',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _registerBirthDateController,
            hint: 'Doğum Tarihi',
            icon: Icons.cake_outlined,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _registerPasswordController,
            hint: 'Şifre',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: _registerPasswordVisible,
            onToggleVisibility: () => setState(
              () => _registerPasswordVisible = !_registerPasswordVisible,
            ),
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _registerConfirmPasswordController,
            hint: 'Şifre Onayla',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: _registerConfirmPasswordVisible,
            onToggleVisibility: () => setState(
              () => _registerConfirmPasswordVisible =
                  !_registerConfirmPasswordVisible,
            ),
          ),
          const SizedBox(height: 18),
          // KVKK Onay
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _kvkkAccepted,
                  onChanged: (val) => setState(() => _kvkkAccepted = val ?? false),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: const BorderSide(color: AppColors.inputBorder, width: 1.5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Kişisel verilerimin işlenmesine yönelik KVKK metnini okudum ve onaylıyorum.',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    color: AppColors.textDark.withValues(alpha: 0.7),
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _buildYellowButton(
            label: 'KAYIT OL',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildSocialRow(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // YARDIMCI WİDGET'LAR
  // ─────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: isPassword && !isPasswordVisible,
      keyboardType: keyboardType,
      style: GoogleFonts.quicksand(
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
        fontSize: 15,
        height: 1.2,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.quicksand(
          color: AppColors.hintText,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14, right: 10),
          child: Icon(icon, color: AppColors.hintText, size: 22),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 50,
          minHeight: 50,
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.hintText,
                  size: 22,
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8F8FC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
            width: 1.4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildYellowButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD3A400),
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.balooChettan2(
                color: AppColors.yellowButtonText,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.divider, thickness: 1.2),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'VEYA',
            style: GoogleFonts.balooChettan2(
              color: AppColors.hintText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.divider, thickness: 1.2),
        ),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialBtn(
          color: const Color(0xFF1877F2),
          icon: Icons.facebook_rounded,
          iconColor: Colors.white,
        ),
        const SizedBox(width: 20),
        _socialBtn(color: Colors.white, child: _GoogleLogo()),
      ],
    );
  }

  Widget _socialBtn({
    required Color color,
    IconData? icon,
    Color? iconColor,
    Widget? child,
  }) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: color == Colors.white
            ? Border.all(color: AppColors.inputBorder, width: 1.5)
            : null,
      ),
      child: Center(child: child ?? Icon(icon, color: iconColor, size: 28)),
    );
  }
}

// ─── Konuşma balonu kuyruğu ────────────────────────
class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Google Logo (renkli G harfi) ────────────────
class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final sw = size.width * 0.22;

    void arc(Color c, double start, double sweep) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.78),
        start * 3.14159 / 180,
        sweep * 3.14159 / 180,
        false,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw
          ..strokeCap = StrokeCap.butt,
      );
    }

    arc(const Color(0xFF4285F4), -90, 90);
    arc(const Color(0xFFEA4335), 180, 90);
    arc(const Color(0xFFFBBC05), 90, 90);
    arc(const Color(0xFF34A853), 0, 90);

    // G yatay kolu
    canvas.drawLine(
      Offset(cx, cy),
      Offset(size.width * 0.95, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
