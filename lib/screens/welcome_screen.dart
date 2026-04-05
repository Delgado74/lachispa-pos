import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/language_provider.dart';
import 'login_screen.dart';
import '../core/theme/app_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _sparkController;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _buttonAnimation;

  final List<Particle> _particles = [];
  final math.Random _random = math.Random();
  Timer? _sparkTimer;
  Size? _screenSize;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    if (_screenSize != null) {
      _setupSparkTimer();
    }
  }

  void _setupAnimations() {
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _sparkController = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..repeat();

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  void _startAnimations() {
    _staggerController.forward();
  }

  void _setupSparkTimer() {
    _sparkTimer?.cancel();
    _sparkTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _createRandomSpark();
    });
  }

  void _createRandomSpark() {
    if (!mounted || _screenSize == null) return;

    final sparkCount = _random.nextInt(3) + 2;

    for (int spark = 0; spark < sparkCount; spark++) {
      final x = _random.nextDouble() * _screenSize!.width;
      final y = _random.nextDouble() * _screenSize!.height;
      final particleCount = _random.nextInt(20) + 10;

      for (int i = 0; i < particleCount; i++) {
        _particles.add(Particle(x, y, _random));
      }
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _sparkController.dispose();
    _sparkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1419), Color(0xFF1A1D47), Color(0xFF2D3FE7)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeTransition(
                opacity: _titleAnimation,
                child: Image.asset(
                  'assets/Logo/chispabordesredondos.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.3),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _sparkController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SparkPainter(_particles),
                  size: Size.infinite,
                );
              },
            ),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildLanguageButton(context),
                    ),
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - _titleAnimation.value)),
                        child: Opacity(
                          opacity: _titleAnimation.value,
                          child: Text(
                            'La ChispaPOS',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 8,
                                  color: const Color(
                                    0xFF2D3FE7,
                                  ).withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: _subtitleAnimation,
                    builder: (context, child) {
                      final l10n = AppLocalizations.of(context)!;
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _subtitleAnimation.value)),
                        child: Opacity(
                          opacity: _subtitleAnimation.value,
                          child: Text(
                            l10n.welcome_subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  AnimatedBuilder(
                    animation: _buttonAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - _buttonAnimation.value)),
                        child: Opacity(
                          opacity: _buttonAnimation.value,
                          child: _buildGradientButton(context),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return IconButton(
      onPressed: () => _showLanguageSelector(context),
      icon: Text(
        languageProvider.getCurrentLanguageFlag(),
        style: const TextStyle(fontSize: 24),
      ),
      tooltip: AppLocalizations.of(context)?.select_language ?? 'Language',
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    final l10n = AppLocalizations.of(context)!;
    final languages = languageProvider.getAvailableLanguages();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.select_language,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return ListTile(
                    leading: Text(
                      lang['flag']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      lang['name']!,
                      style: TextStyle(
                        color:
                            languageProvider.currentLocale.languageCode ==
                                lang['code']
                            ? AppTheme.primaryColor
                            : Colors.white,
                      ),
                    ),
                    trailing:
                        languageProvider.currentLocale.languageCode ==
                            lang['code']
                        ? const Icon(Icons.check, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      languageProvider.changeLanguage(Locale(lang['code']!));
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF2D3FE7), Color(0xFF4C63F7)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D3FE7).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            l10n.get_started_button,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  double speedX;
  double speedY;
  double life;
  final double decay;

  Particle(this.x, this.y, math.Random random)
    : size = (random.nextDouble() * 3 + 1.0),
      speedX = _generateOrganicVelocity(random),
      speedY = _generateOrganicVelocity(random),
      life = 100,
      decay = random.nextDouble() * 1.5 + 0.5;

  static double _generateOrganicVelocity(math.Random random) {
    final angle = random.nextDouble() * 2 * math.pi;
    final intensity = random.nextDouble() * 4 + 2;
    final direction = random.nextBool() ? 1 : -1;
    return math.cos(angle) * intensity * direction;
  }

  void update() {
    x += speedX;
    y += speedY;
    life -= decay;
    speedX *= 0.99;
    speedY *= 0.99;
  }

  bool get isAlive => life > 0;

  double get opacity {
    final normalizedLife = life / 100;
    return 1 - math.pow(1 - normalizedLife, 4).toDouble();
  }
}

class SparkPainter extends CustomPainter {
  final List<Particle> particles;

  SparkPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    particles.removeWhere((particle) {
      particle.update();
      return !particle.isAlive;
    });

    final devicePixelRatio = 1.0;

    for (final particle in particles) {
      final alpha = particle.opacity;
      if (alpha <= 0) continue;

      final center = Offset(particle.x, particle.y);
      final scaledSize = particle.size * devicePixelRatio;

      const primaryColor = Color(0xFF5B73FF);
      const secondaryColor = Color(0xFF4C63F7);

      final glowPaint2 = Paint()
        ..color = primaryColor.withValues(alpha: alpha * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      canvas.drawCircle(center, scaledSize * 2, glowPaint2);

      final glowPaint1 = Paint()
        ..color = secondaryColor.withValues(alpha: alpha * 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      canvas.drawCircle(center, scaledSize * 1.5, glowPaint1);

      final particlePaint = Paint()
        ..color = primaryColor.withValues(alpha: alpha * 0.9);

      canvas.drawCircle(center, scaledSize, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
