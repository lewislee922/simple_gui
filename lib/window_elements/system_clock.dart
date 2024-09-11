import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SystemClock extends StatefulWidget {
  const SystemClock({super.key});

  @override
  State<SystemClock> createState() => _SystemClockState();
}

class _SystemClockState extends State<SystemClock> {
  late DateTime _time;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _time = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _time = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("HH:mm yyyy/M/dd");
    return Text(
      formatter.format(_time),
      style: const TextStyle(fontSize: 20, height: 1),
    );
  }
}
