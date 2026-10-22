import 'package:flutter/material.dart';
import 'package:streak_up/app/theme/app_colors.dart';

/// Approved scalable artwork retained to preserve appearance without inventing assets.
class AuthBackgroundArtwork extends CustomPainter {
  const AuthBackgroundArtwork();
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final mint = Paint()..color = AppColors.selectedGreenPill;
    canvas.drawPath(
      Path()
        ..moveTo(w * .57, 0)
        ..cubicTo(w * .64, h * .13, w * .90, h * .07, w, h * .19)
        ..lineTo(w, 0)
        ..close(),
      mint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, h - 160)
        ..cubicTo(w * .40, h - 160, w * .48, h - 25, w, h - 105)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      mint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, h - 95)
        ..cubicTo(w * .36, h - 95, w * .66, h - 40, w, h - 95)
        ..lineTo(w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = AppColors.selectedGreenPill.withValues(alpha: .6),
    );
    final leaf = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF98DEAB), Color(0xFF5DC392)],
      ).createShader(Rect.fromLTWH(0, h - 135, w * .5, 135));
    void drawLeaf(Offset start, Offset end, double width) {
      final middle = (start + end) / 2;
      final normal = Offset(-(end - start).dy, (end - start).dx);
      final scaled = normal / normal.distance * width;
      canvas.drawPath(
        Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(
            (middle + scaled).dx,
            (middle + scaled).dy,
            end.dx,
            end.dy,
          )
          ..quadraticBezierTo(
            (middle - scaled).dx,
            (middle - scaled).dy,
            start.dx,
            start.dy,
          )
          ..close(),
        leaf,
      );
    }

    drawLeaf(Offset(-5, h + 15), Offset(w * .23, h - 94), 36);
    drawLeaf(Offset(w * .12, h + 15), Offset(w * .29, h - 63), 23);
    drawLeaf(Offset(w * .07, h - 96), Offset(w * .13, h - 128), 10);
    drawLeaf(Offset(w * .33, h - 40), Offset(w * .41, h - 65), 9);
  }

  @override
  bool shouldRepaint(AuthBackgroundArtwork oldDelegate) => false;
}

/// Reused by verification and both recovery-email views.
class AuthEmailIllustration extends StatelessWidget {
  const AuthEmailIllustration({super.key, this.badge});
  final IconData? badge;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: 136,
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _EmailArtwork())),
          if (badge != null)
            PositionedDirectional(
              bottom: 0,
              end: 0,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.selectedGreenPill,
                  border: Border.all(color: AppColors.surface, width: 4),
                ),
                child: Icon(badge, color: AppColors.greenDark, size: 24),
              ),
            ),
        ],
      ),
    ),
  );
}

class _EmailArtwork extends CustomPainter {
  const _EmailArtwork();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      const Offset(68, 68),
      68,
      Paint()..color = AppColors.selectedGreenPill,
    );
    final green = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF41B75F), Color(0xFF109E5E)],
      ).createShader(const Rect.fromLTWH(20, 25, 96, 94));
    canvas.drawPath(
      Path()
        ..moveTo(22, 65)
        ..lineTo(68, 27)
        ..lineTo(114, 65)
        ..lineTo(114, 118)
        ..lineTo(22, 118)
        ..close(),
      green,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(33, 40, 70, 73),
        const Radius.circular(6),
      ),
      Paint()..color = AppColors.surface,
    );
    final lines = Paint()
      ..color = const Color(0xFFD3EBE1)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (final y in [56.0, 67.0, 78.0]) {
      canvas.drawLine(Offset(48, y), Offset(90, y), lines);
    }
    final front = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFB4DE9D), Color(0xFF72CBA3)],
      ).createShader(const Rect.fromLTWH(22, 65, 92, 54));
    canvas.drawPath(
      Path()
        ..moveTo(22, 65)
        ..lineTo(68, 97)
        ..lineTo(114, 65)
        ..lineTo(114, 119)
        ..lineTo(22, 119)
        ..close(),
      front,
    );
    canvas.drawPath(
      Path()
        ..moveTo(22, 119)
        ..lineTo(68, 86)
        ..lineTo(114, 119)
        ..close(),
      Paint()..color = const Color(0xFF99D7AF),
    );
  }

  @override
  bool shouldRepaint(_EmailArtwork oldDelegate) => false;
}
