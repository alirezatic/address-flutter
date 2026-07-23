import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedStartButton extends StatefulWidget {
  const AnimatedStartButton({
    required this.onTap,
    required this.isLoading,
    this.title,
    this.icon,
    super.key,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final String? title;
  final IconData? icon;

  @override
  State<AnimatedStartButton> createState() => _AnimatedStartButtonState();
}

class _AnimatedStartButtonState extends State<AnimatedStartButton>
    with TickerProviderStateMixin {
  static const Color _background = Color(0xFF072044);
  static const Color _background1 = Color(0xFF193B72);
  static const Color _background2 = Color(0xFF4D6CA0);

  late final AnimationController _glow;
  late final AnimationController _sweep;
  late final AnimationController _iconAnimation;
  late final AnimationController _press;
  late final Animation<double> _pressScale;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _iconAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    _pressScale = Tween<double>(
      begin: 1,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _press, curve: Curves.easeOutBack));
  }

  @override
  void didUpdateWidget(covariant AnimatedStartButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading) {
      _iconAnimation.forward();
    } else {
      _iconAnimation.reverse();
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    _sweep.dispose();
    _iconAnimation.dispose();
    _press.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    if (widget.isLoading) {
      return;
    }

    HapticFeedback.lightImpact();
    _pressed = true;
    _press.forward();
  }

  void _tapUp(TapUpDetails details) {
    if (widget.isLoading) {
      return;
    }

    _pressed = false;
    _press.reverse();
  }

  void _tapCancel() {
    if (widget.isLoading) {
      return;
    }

    _pressed = false;
    _press.reverse();
  }

  int _alpha(double value) => (value * 255).round().clamp(0, 255);

  double _clamp(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final buttonWidth = viewportWidth < 600
        ? _clamp(viewportWidth * 0.56, 190, 240)
        : 220.0;

    const buttonHeight = 58.0;
    const textSize = 16.0;
    const iconSize = 30.0;
    const loaderSize = 24.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.isLoading ? null : _tapDown,
      onTapUp: widget.isLoading ? null : _tapUp,
      onTapCancel: widget.isLoading ? null : _tapCancel,
      onTap: widget.isLoading ? null : widget.onTap,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([_glow, _sweep, _press]),
          builder: (context, child) {
            final glow = _glow.value;

            return Transform.scale(
              scale: _pressScale.value,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(buttonHeight / 2),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _background1.withAlpha(_alpha(0.9 + glow * 0.1)),
                      _background.withAlpha(_alpha(0.75 + glow * 0.1)),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _background2.withAlpha(_alpha(0.6 * glow)),
                      blurRadius: 25 + (15 * glow),
                      spreadRadius: 2 + (2 * glow),
                    ),
                    BoxShadow(
                      color: Colors.black.withAlpha(_alpha(0.25)),
                      blurRadius: _pressed ? 6 : 16,
                      offset: Offset(0, _pressed ? 4 : 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(buttonHeight / 2),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _LiquidHighlightPainter(
                            progress: _sweep.value,
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _iconAnimation,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 1 - _iconAnimation.value,
                                child: _buildContent(textSize, iconSize),
                              ),
                              Opacity(
                                opacity: _iconAnimation.value,
                                child: const SizedBox(
                                  width: loaderSize,
                                  height: loaderSize,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(double textSize, double iconSize) {
    if (widget.title != null && widget.title!.isNotEmpty) {
      return Text(
        widget.title!,
        style: TextStyle(
          color: Colors.white,
          fontSize: textSize,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Icon(
      widget.icon ?? Icons.arrow_forward_rounded,
      color: Colors.white,
      size: iconSize,
    );
  }
}

class _LiquidHighlightPainter extends CustomPainter {
  const _LiquidHighlightPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withValues(alpha: 0.25), Colors.transparent],
        radius: 0.6,
        center: Alignment(-1 + (2 * progress), -0.2),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidHighlightPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
