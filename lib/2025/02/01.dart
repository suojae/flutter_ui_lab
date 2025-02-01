import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

final class BouncedButton extends StatefulWidget {
  const BouncedButton({super.key});

  @override
  State<BouncedButton> createState() => _BouncedButtonState();
}

class _BouncedButtonState extends State<BouncedButton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final _scale = Tween<double>(begin: 1, end: 0.9)
      .chain(CurveTween(curve: Curves.easeOut))
      .animate(_controller);

  final _fingerprints = ValueNotifier<List<Widget>>([]);

  bool _isPressed = false;

  @override
  void dispose() {
    _controller.dispose();
    _fingerprints.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
        _addFingerprint(details.localPosition);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scale,
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(
            width: 240,
            height: 72,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: const Color(0xFF343434),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 8),
                        blurRadius: 12,
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: ValueListenableBuilder(
                valueListenable: _fingerprints,
                builder: (context, fingerprints, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        'Touch Me',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      ...fingerprints,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addFingerprint(Offset position) {
    final random = math.Random();
    final opacity = random.nextDouble() * 0.4 + 0.2;
    final angle = random.nextDouble() * 0.7 - 0.35;
    final index = random.nextInt(5);

    final fingerprints = _fingerprints.value;

    _fingerprints.value = List.of(fingerprints)
      ..add(
        Positioned(
          key: ValueKey(fingerprints.length),
          top: position.dy,
          left: position.dx,
          child: FractionalTranslation(
            translation: const Offset(-0.5, -0.5),
            child: Transform.rotate(
              angle: angle,
              child: BackdropFilter(
                filter: ImageFilter.blur(),
                blendMode: BlendMode.lighten,
                child: Image.asset(
                  'assets/fingerprint-$index.png',
                  height: 90,
                  width: 90,
                  opacity: AlwaysStoppedAnimation(opacity),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
