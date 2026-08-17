import 'dart:math';
import 'package:flutter/material.dart';

class RotatingContainer extends StatefulWidget {
  const RotatingContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  RotatingContainerState createState() => RotatingContainerState();
}

class RotatingContainerState extends State<RotatingContainer>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    final localController = _controller;
    if (localController == null) return;

    _rotationAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: localController, curve: Curves.linear),
    );
    _rotate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _rotate() {
    _controller?.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final localAnimation = _rotationAnimation;
    if (localAnimation == null) return Container();

    return RotationTransition(
      turns: localAnimation,
      child: widget.child,
    );
  }
}
