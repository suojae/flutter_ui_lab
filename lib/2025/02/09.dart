import 'package:flutter/material.dart';

class CustomBottomNavScreen extends StatelessWidget {
  CustomBottomNavScreen({super.key});

  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  void _onItemTapped(int index) {
    print("Tapped index: $index");
    selectedIndexNotifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: selectedIndexNotifier,
          builder: (context, selectedIndex, _) {
            return Text(
              'Selected Index: $selectedIndex',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 10,
          shape: BoxShape.circle,
          shadowColor: Colors.black54,
          child: FloatingActionButton(
            onPressed: () {
              print("Floating Action Button pressed");
            },
            backgroundColor: const Color(0xFFE14F4A),
            elevation: 3,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 36, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // BottomNavigationBar 영역
      bottomNavigationBar: Container(
        height: 100,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 100),
              painter: BottomNavPainter(),
            ),
            Material(
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15),
                  child: ValueListenableBuilder<int>(
                    valueListenable: selectedIndexNotifier,
                    builder: (context, selectedIndex, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.home,
                              size: 32,
                              color: selectedIndex == 0
                                  ? const Color(0xFFF37C78)
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              print("Home icon pressed");
                              _onItemTapped(0);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.person,
                              size: 32,
                              color: selectedIndex == 1
                                  ? const Color(0xFFF37C78)
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              print("Person icon pressed");
                              _onItemTapped(1);
                            },
                          ),
                        ],
                      );
                    },
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

class BottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dip = 50.0;
    double width = size.width;
    double height = size.height;

    double curveWidth = width * 0.45;
    double leftX = (width - curveWidth) / 2;
    double rightX = leftX + curveWidth;

    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(leftX, 0);
    path.cubicTo(
      leftX + curveWidth / 4,
      0,
      width / 2 - curveWidth / 4,
      dip,
      width / 2,
      dip,
    );
    path.cubicTo(
      width / 2 + curveWidth / 4,
      dip,
      rightX - curveWidth / 4,
      0,
      rightX,
      0,
    );
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    final Paint shadowPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.save();
    canvas.translate(0, -4);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool hitTest(Offset position) => false;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
