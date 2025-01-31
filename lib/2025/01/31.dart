import 'dart:ui';
import 'package:flutter/material.dart';

final class GlassMorphismEffect extends StatelessWidget {
  const GlassMorphismEffect({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.2,
    this.color = Colors.white,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
  });

  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color.withValues(alpha: opacity),
              borderRadius: borderRadius,
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}


final class TouchBlur extends StatefulWidget {
  const TouchBlur({super.key});

  @override
  _TouchBlurState createState() => _TouchBlurState();
}

class _TouchBlurState extends State<TouchBlur> with SingleTickerProviderStateMixin {
  Offset? _tapPosition;
  double _blurAmount = 20.0; // 기본 블러 강도
  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _blurAnimation = Tween<double>(begin: 0, end: _blurAmount).animate(_controller);
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition; // 터치한 위치 저장
    });

    _controller.forward(from: 0); // 블러 애니메이션 시작
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blurAnimation,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: GestureDetector(
              onTapDown: _onTapDown, // 탭하면 블러 위치 변경
              child: Stack(
                children: [
                  // 배경 이미지
                  Positioned.fill(
                    child: Image.network(
                      'https://cdn.britannica.com/34/235834-050-C5843610/two-different-breeds-of-cats-side-by-side-outdoors-in-the-garden.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // 사용자가 터치한 위치에만 블러 적용
                  if (_tapPosition != null)
                    Positioned(
                      left: _tapPosition!.dx - 75,
                      top: _tapPosition!.dy - 75,
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _blurAnimation.value,
                            sigmaY: _blurAnimation.value,
                          ),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
