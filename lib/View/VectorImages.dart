import 'package:flutter/material.dart';
import 'dart:math';

class OnboardingVectors {
  static Widget calculationVector(BuildContext context, {double size = 200}) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CalculationPainter(
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
      ),
    );
  }

  static Widget offersVector(BuildContext context, {double size = 200}) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: OffersPainter(
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
      ),
    );
  }

  static Widget feesVector(BuildContext context, {double size = 200}) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: FeesPainter(
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
      ),
    );
  }

  static Widget premiumVector(BuildContext context, {double size = 200}) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PremiumPainter(
          primaryColor: primaryColor,
          accentColor: accentColor,
        ),
      ),
    );
  }
}

class CalculationPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  CalculationPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    // Draw calculator
    final calculatorRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.2, size.width * 0.6, size.height * 0.6),
      Radius.circular(10),
    );

    canvas.drawRRect(calculatorRect, fillPaint);
    canvas.drawRRect(calculatorRect, paint);

    // Draw display
    final displayRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.25, size.width * 0.5, size.height * 0.15),
      Radius.circular(5),
    );

    canvas.drawRRect(displayRect, Paint()..color = Colors.white);
    canvas.drawRRect(displayRect, paint);

    // Draw buttons
    final buttonSize = size.width * 0.12;
    final startX = size.width * 0.25;
    final startY = size.height * 0.45;
    final spacing = size.width * 0.04;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final buttonRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            startX + col * (buttonSize + spacing),
            startY + row * (buttonSize + spacing),
            buttonSize,
            buttonSize,
          ),
          Radius.circular(5),
        );

        canvas.drawRRect(buttonRect, accentPaint);
      }
    }

    // Draw needle and thread
    final needleStart = Offset(size.width * 0.1, size.height * 0.3);
    final needleEnd = Offset(size.width * 0.15, size.height * 0.7);

    canvas.drawLine(
      needleStart,
      needleEnd,
      Paint()
        ..color = Colors.grey.shade700
        ..strokeWidth = 2.0,
    );

    // Draw thread
    final threadPath = Path()
      ..moveTo(needleStart.dx, needleStart.dy)
      ..cubicTo(
        size.width * 0.05, size.height * 0.4,
        size.width * 0.15, size.height * 0.5,
        size.width * 0.05, size.height * 0.6,
      )
      ..cubicTo(
        size.width * 0.15, size.height * 0.7,
        size.width * 0.05, size.height * 0.8,
        size.width * 0.15, size.height * 0.9,
      );

    canvas.drawPath(
      threadPath,
      Paint()
        ..color = accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OffersPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  OffersPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    // Draw document
    final documentRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.15, size.width * 0.6, size.height * 0.7),
      Radius.circular(10),
    );

    canvas.drawRRect(documentRect, fillPaint);
    canvas.drawRRect(documentRect, paint);

    // Draw document lines
    for (int i = 1; i <= 5; i++) {
      final y = size.height * (0.25 + i * 0.1);
      canvas.drawLine(
        Offset(size.width * 0.3, y),
        Offset(size.width * 0.7, y),
        Paint()
          ..color = primaryColor.withOpacity(0.5)
          ..strokeWidth = 2.0,
      );
    }

    // Draw checkmark
    final checkPath = Path()
      ..moveTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.4)
      ..lineTo(size.width * 0.95, size.height * 0.2);

    canvas.drawPath(
      checkPath,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw scissors
    final scissorsCenter = Offset(size.width * 0.15, size.height * 0.7);

    // Handle
    canvas.drawLine(
      scissorsCenter,
      Offset(size.width * 0.05, size.height * 0.85),
      Paint()
        ..color = Colors.grey.shade700
        ..strokeWidth = 3.0,
    );

    // Blades
    final blade1 = Path()
      ..moveTo(scissorsCenter.dx, scissorsCenter.dy)
      ..lineTo(size.width * 0.25, size.height * 0.55)
      ..lineTo(size.width * 0.15, size.height * 0.5)
      ..close();

    final blade2 = Path()
      ..moveTo(scissorsCenter.dx, scissorsCenter.dy)
      ..lineTo(size.width * 0.25, size.height * 0.85)
      ..lineTo(size.width * 0.15, size.height * 0.9)
      ..close();

    canvas.drawPath(blade1, accentPaint);
    canvas.drawPath(blade2, accentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FeesPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  FeesPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    // Draw chart background
    final chartRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, size.width * 0.8, size.height * 0.6),
      Radius.circular(10),
    );

    canvas.drawRRect(chartRect, fillPaint);
    canvas.drawRRect(chartRect, paint);

    // Draw chart bars
    final barWidth = size.width * 0.15;
    final barSpacing = size.width * 0.1;
    final baseY = size.height * 0.7;

    // Bar 1
    final bar1Height = size.height * 0.2;
    final bar1Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2,
        baseY - bar1Height,
        barWidth,
        bar1Height,
      ),
      Radius.circular(5),
    );

    // Bar 2
    final bar2Height = size.height * 0.3;
    final bar2Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2 + barWidth + barSpacing,
        baseY - bar2Height,
        barWidth,
        bar2Height,
      ),
      Radius.circular(5),
    );

    // Bar 3
    final bar3Height = size.height * 0.15;
    final bar3Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2 + 2 * (barWidth + barSpacing),
        baseY - bar3Height,
        barWidth,
        bar3Height,
      ),
      Radius.circular(5),
    );

    canvas.drawRRect(bar1Rect, accentPaint);
    canvas.drawRRect(bar2Rect, Paint()..color = primaryColor);
    canvas.drawRRect(bar3Rect, accentPaint);

    // Draw horizontal lines
    for (int i = 1; i <= 3; i++) {
      final y = baseY - (size.height * 0.1 * i);
      canvas.drawLine(
        Offset(size.width * 0.15, y),
        Offset(size.width * 0.85, y),
        Paint()
          ..color = primaryColor.withOpacity(0.5)
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round,
      );
    }

    // Draw percentage symbols
    final textPainter = TextPainter(
      text: TextSpan(
        text: '%',
        style: TextStyle(
          color: primaryColor,
          fontSize: size.width * 0.08,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.05, size.height * 0.3));
    textPainter.paint(canvas, Offset(size.width * 0.05, size.height * 0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PremiumPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  PremiumPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final goldPaint = Paint()
      ..color = Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Draw crown
    final crownPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.3)
      ..close();

    canvas.drawPath(crownPath, goldPaint);
    canvas.drawPath(
      crownPath,
      Paint()
        ..color = Colors.orange.shade800
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Draw crown jewels
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.4),
      size.width * 0.03,
      Paint()..color = Colors.red,
    );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.4),
      size.width * 0.03,
      Paint()..color = Colors.blue,
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.4),
      size.width * 0.03,
      Paint()..color = Colors.green,
    );

    // Draw badge
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.55, size.width * 0.4, size.height * 0.3),
      Radius.circular(10),
    );

    canvas.drawRRect(badgeRect, fillPaint);
    canvas.drawRRect(badgeRect, paint);

    // Draw star
    final starCenter = Offset(size.width * 0.5, size.height * 0.7);
    final starOuterRadius = size.width * 0.15;
    final starInnerRadius = starOuterRadius * 0.4;

    final starPath = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = 2 * pi * i / 5 - pi / 2;
      final innerAngle = 2 * pi * (i + 0.5) / 5 - pi / 2;

      final outerX = starCenter.dx + cos(outerAngle) * starOuterRadius;
      final outerY = starCenter.dy + sin(outerAngle) * starOuterRadius;

      final innerX = starCenter.dx + cos(innerAngle) * starInnerRadius;
      final innerY = starCenter.dy + sin(innerAngle) * starInnerRadius;

      if (i == 0) {
        starPath.moveTo(outerX, outerY);
      } else {
        starPath.lineTo(outerX, outerY);
      }

      starPath.lineTo(innerX, innerY);
    }
    starPath.close();

    canvas.drawPath(starPath, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
