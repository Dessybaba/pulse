import 'dart:math' as math;
import 'package:flutter/material.dart';

/// An animated ECG-style pulse line — Pulse's signature visual.
/// Used as the loading indicator and as a static accent on the total card.
class PulseLine extends StatefulWidget {
  final Color color;
  final double height;
  final bool animate;

  const PulseLine({
    super.key,
    required this.color,
    this.height = 40,
    this.animate = true,
  });

  @override
  State<PulseLine> createState() => _PulseLineState();
}

class _PulseLineState extends State<PulseLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _PulsePainter(
              progress: widget.animate ? _controller.value : 0.0,
              color: widget.color,
              animate: widget.animate,
            ),
          );
        },
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool animate;

  _PulsePainter({
    required this.progress,
    required this.color,
    required this.animate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height / 2;
    final spikeStart = size.width * 0.42;
    final spikeWidth = size.width * 0.16;

    path.moveTo(0, midY);
    path.lineTo(spikeStart, midY);
    path.lineTo(spikeStart + spikeWidth * 0.25, midY - size.height * 0.35);
    path.lineTo(spikeStart + spikeWidth * 0.5, midY + size.height * 0.45);
    path.lineTo(spikeStart + spikeWidth * 0.75, midY - size.height * 0.15);
    path.lineTo(spikeStart + spikeWidth, midY);
    path.lineTo(size.width, midY);

    if (!animate) {
      canvas.drawPath(path, paint);
      return;
    }

    // Sweep a highlighted segment across the line to suggest a live pulse.
    final metrics = path.computeMetrics().toList();
    final basePaint = paint..color = color.withOpacity(0.18);
    for (final m in metrics) {
      canvas.drawPath(m.extractPath(0, m.length), basePaint);
    }

    final sweepPaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final m in metrics) {
      final total = m.length;
      final segLen = total * 0.25;
      final start = (progress * total * 1.4) % (total + segLen) - segLen;
      final clampedStart = math.max(0.0, start);
      final end = math.min(total, start + segLen);
      if (end > clampedStart) {
        canvas.drawPath(m.extractPath(clampedStart, end), sweepPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PulsePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
