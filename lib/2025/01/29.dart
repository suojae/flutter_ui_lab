import 'package:flutter/material.dart';

final class ShadowBox01 extends StatelessWidget {
  const ShadowBox01({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurStyle: BlurStyle.inner,
                offset: Offset(10, 10))
          ]),
    );
  }
}

final class ShadowBox02 extends StatelessWidget {
  const ShadowBox02({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 4,
            offset: const Offset(6, 6),
          ),
        ],
      ),
    );
  }
}
