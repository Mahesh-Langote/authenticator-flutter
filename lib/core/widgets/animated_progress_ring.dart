import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/app_colors.dart';

class AnimatedProgressRing extends StatelessWidget {
  final double progress;
  final int remainingSeconds;
  final double size;

  const AnimatedProgressRing({
    Key? key,
    required this.progress,
    required this.remainingSeconds,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = remainingSeconds <= 5 ? AppColors.error : AppColors.primary;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: progress, end: progress),
            duration: const Duration(milliseconds: 100),
            builder: (context, value, _) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 4,
                backgroundColor: AppColors.timerTrack,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
          Center(
            child: Text(
              '$remainingSeconds',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
