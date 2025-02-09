import 'package:flutter/material.dart';

class ThreeDButtonScreen extends StatefulWidget {
  const ThreeDButtonScreen({super.key});

  @override
  _ThreeDButtonScreenState createState() => _ThreeDButtonScreenState();
}

class _ThreeDButtonScreenState extends State<ThreeDButtonScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _iconScaleAnimation;

  bool isBoxShadowPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevationAnimation = Tween<double>(begin: 20, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _onBoxShadowTapDown() {
    setState(() {
      isBoxShadowPressed = true;
    });
  }

  void _onBoxShadowTapUp() {
    setState(() {
      isBoxShadowPressed = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("PhysicalModel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              behavior: HitTestBehavior.translucent,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedPhysicalModel(
                      duration: const Duration(milliseconds: 200),
                      shape: BoxShape.circle,
                      color: Colors.amber,
                      elevation: _elevationAnimation.value,
                      shadowColor: Colors.black54,
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Center(
                          child: Transform.scale(
                            scale: _iconScaleAnimation.value,
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
            const Text("Container + BoxShadow", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTapDown: (_) => _onBoxShadowTapDown(),
              onTapUp: (_) => _onBoxShadowTapUp(),
              behavior: HitTestBehavior.translucent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(isBoxShadowPressed ? 0.95 : 1.0),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: isBoxShadowPressed ? 5 : 15,
                      spreadRadius: isBoxShadowPressed ? 2 : 5,
                      offset: isBoxShadowPressed ? const Offset(2, 2) : const Offset(6, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Transform.scale(
                    scale: isBoxShadowPressed ? 1.0 : 1.0,
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
