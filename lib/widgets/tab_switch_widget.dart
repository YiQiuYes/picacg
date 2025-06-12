import 'package:flutter/material.dart';

class TabSwitchWidget extends StatelessWidget {
  const TabSwitchWidget({
    super.key,
    required this.children,
    required this.currentIndex,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final List<Widget> children;
  final int currentIndex;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: children[currentIndex],
    );
  }
}
