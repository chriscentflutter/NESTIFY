import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:nestify/config/theme/app_colors.dart';

class WaveBackground extends StatelessWidget {
  final Widget child;
  final bool showGradient;
  final double waveHeight;
  
  const WaveBackground({
    Key? key,
    required this.child,
    this.showGradient = true,
    this.waveHeight = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: BoxDecoration(
            gradient: showGradient ? AppColors.waveGradient : null,
            color: showGradient ? null : AppColors.richBlack,
          ),
        ),
        
        // Animated Wave Pattern
        Positioned.fill(
          child: CustomPaint(
            painter: WavePainter(),
          ),
        ),
        
        // Content
        child,
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = AppColors.primaryRed.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    
    final paint2 = Paint()
      ..color = AppColors.crimson.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    
    final paint3 = Paint()
      ..color = AppColors.darkRed.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    
    // First Wave
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    
    for (double i = 0; i <= size.width; i++) {
      path1.lineTo(
        i,
        size.height * 0.3 + 30 * math.sin((i / size.width * 2 * math.pi) + 0),
      );
    }
    
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();
    
    canvas.drawPath(path1, paint1);
    
    // Second Wave
    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    
    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
        i,
        size.height * 0.5 + 40 * math.sin((i / size.width * 2 * math.pi) + math.pi / 2),
      );
    }
    
    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.close();
    
    canvas.drawPath(path2, paint2);
    
    // Third Wave
    final path3 = Path();
    path3.moveTo(0, size.height * 0.7);
    
    for (double i = 0; i <= size.width; i++) {
      path3.lineTo(
        i,
        size.height * 0.7 + 50 * math.sin((i / size.width * 2 * math.pi) + math.pi),
      );
    }
    
    path3.lineTo(size.width, 0);
    path3.lineTo(0, 0);
    path3.close();
    
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated Wave Background
class AnimatedWaveBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedWaveBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedWaveBackground> createState() => _AnimatedWaveBackgroundState();
}

class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.waveGradient,
          ),
        ),
        
        // Animated Wave Pattern
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: AnimatedWavePainter(_controller.value),
              child: Container(),
            );
          },
        ),
        
        // Content
        widget.child,
      ],
    );
  }
}

class AnimatedWavePainter extends CustomPainter {
  final double animationValue;
  
  AnimatedWavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = AppColors.primaryRed.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    
    final paint2 = Paint()
      ..color = AppColors.crimson.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    
    final paint3 = Paint()
      ..color = AppColors.darkRed.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    
    final offset = animationValue * 2 * math.pi;
    
    // First Wave
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    
    for (double i = 0; i <= size.width; i++) {
      path1.lineTo(
        i,
        size.height * 0.3 + 30 * math.sin((i / size.width * 2 * math.pi) + offset),
      );
    }
    
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();
    
    canvas.drawPath(path1, paint1);
    
    // Second Wave
    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    
    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
        i,
        size.height * 0.5 + 40 * math.sin((i / size.width * 2 * math.pi) + offset + math.pi / 2),
      );
    }
    
    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.close();
    
    canvas.drawPath(path2, paint2);
    
    // Third Wave
    final path3 = Path();
    path3.moveTo(0, size.height * 0.7);
    
    for (double i = 0; i <= size.width; i++) {
      path3.lineTo(
        i,
        size.height * 0.7 + 50 * math.sin((i / size.width * 2 * math.pi) + offset + math.pi),
      );
    }
    
    path3.lineTo(size.width, 0);
    path3.lineTo(0, 0);
    path3.close();
    
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(AnimatedWavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
