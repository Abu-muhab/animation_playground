import 'package:flutter/material.dart';

class TimerCard extends StatefulWidget {
  final MaterialColor color;
  TimerCard({required this.color});
  @override
  _TimerCardState createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        height: constraint.maxHeight,
        width: constraint.maxWidth,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (conext, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomPaint(
                painter: TimerCardPainter(
                  animation: _controller,
                  color: widget.color,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class TimerCardPainter extends CustomPainter {
  final AnimationController animation;
  late final Tween<double> leftRidgeTweenY;
  late final Tween<double> leftRidgeTweenX;
  late final Tween<double> rightRidgeTweenY;
  late final Tween<double> rightRidgeTweenX;

  final MaterialColor color;
  TimerCardPainter({required this.animation, required this.color}) {}

  @override
  void paint(Canvas canvas, Size size) {
    leftRidgeTweenY = Tween<double>(
      begin: 30,
      end: -30,
    );
    rightRidgeTweenY = Tween<double>(
      begin: -30,
      end: 30,
    );
    leftRidgeTweenX = Tween<double>(
      begin: size.width * 0.3,
      end: 0,
    );

    rightRidgeTweenX = Tween<double>(
      begin: size.width * 0.6,
      end: size.width * 0.3,
    );

    Paint paint = Paint();
    paint.color = color[200]!;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        paint);

    Path secondaryWave = Path();
    paint.color = color[300]!;
    double secondaryWaveY = size.height * 0.25;
    secondaryWave.moveTo(0, secondaryWaveY);
    secondaryWave.cubicTo(
        leftRidgeTweenX.evaluate(animation),
        secondaryWaveY + leftRidgeTweenY.evaluate(animation),
        rightRidgeTweenX.evaluate(animation),
        secondaryWaveY + rightRidgeTweenY.evaluate(animation),
        size.width,
        size.height * 0.3);
    secondaryWave.lineTo(size.width, size.height);
    secondaryWave.lineTo(0, size.height);
    secondaryWave.lineTo(0, secondaryWaveY);
    canvas.drawPath(secondaryWave, paint);

    Path primaryWave = Path();
    paint.color = color;
    double waveY = size.height * 0.3;
    primaryWave.moveTo(0, waveY);
    primaryWave.cubicTo(
        // size.width * 0.3,
        leftRidgeTweenX.evaluate(animation),
        waveY + leftRidgeTweenY.evaluate(animation),
        // size.width * 0.6,
        rightRidgeTweenX.evaluate(animation),
        waveY + rightRidgeTweenY.evaluate(animation),
        size.width,
        size.height * 0.3);
    primaryWave.lineTo(size.width, size.height);
    primaryWave.lineTo(0, size.height);
    primaryWave.lineTo(0, waveY);
    canvas.drawPath(primaryWave, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
