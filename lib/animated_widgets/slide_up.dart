import 'package:flutter/material.dart';

class SlideUp extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve? curve;

  const SlideUp(
      {super.key, required this.duration, this.curve, required this.child});

  @override
  State<StatefulWidget> createState() => SlideUpState();
}

class SlideUpState extends State<SlideUp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: widget.curve ?? Curves.easeIn));
    Future.delayed(Duration(
            milliseconds: (widget.duration.inMilliseconds * 0.3).toInt()))
        .then((_) => _animationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _slideAnimation, child: widget.child);
  }
}
