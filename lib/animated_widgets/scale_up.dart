import 'package:flutter/material.dart';

class ScaleUp extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve? curve;
  const ScaleUp(
      {super.key, required this.child, required this.duration, this.curve});

  @override
  _ScaleUpState createState() => _ScaleUpState();
}

class _ScaleUpState extends State<ScaleUp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: widget.curve ?? Curves.easeIn));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      alignment: Alignment.center,
      child: widget.child,
    );
  }
}
