import 'dart:math';
import 'dart:ui';
import 'package:animations/widgets/timer_card.dart';
import 'package:flutter/material.dart';

class FlyingExpandingCardAnimationPage extends StatefulWidget {
  @override
  createState() => _FlyingExpandingCardAnimationPageState();
}

class _FlyingExpandingCardAnimationPageState
    extends State<FlyingExpandingCardAnimationPage> {
  List<Widget> cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SizedBox(
              height: constraint.maxHeight,
              width: constraint.maxWidth,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                double totalWdith =
                                    MediaQuery.of(context).size.width;

                                double childWidth = 135;

                                Size endChildSize =
                                    Size(childWidth, childWidth * 1.15);

                                MaterialColor color = getRandomMaterialColor();

                                cards.add(FlyExpandTransition(
                                  canvasSize: Size(constraint.maxWidth,
                                      constraint.maxHeight),
                                  startRotation: pi,
                                  endRotation: 0,
                                  startChildStartSize: Size(10, 10),
                                  startChildEndSize: Size(100, 100),
                                  origin: Offset(details.globalPosition.dx,
                                      details.globalPosition.dy),
                                  destination: Offset(
                                      (endChildSize.width / 2) +
                                          calculateColumn(
                                                  cards.length,
                                                  (totalWdith / childWidth)
                                                      .floor()) *
                                              endChildSize.width,
                                      (constraint.maxHeight -
                                              endChildSize.height / 2) -
                                          calculateRow(
                                                  cards.length,
                                                  (totalWdith / childWidth)
                                                      .floor()) *
                                              endChildSize.height),
                                  startChild: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: color),
                                  ),
                                  endChild: TimerCard(
                                    color: color,
                                  ),
                                  endChildSize: Size(endChildSize.width - 10,
                                      endChildSize.height - 10),
                                ));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.greenAccent[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FittedBox(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.green[900],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                cards = [];
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.redAccent[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FittedBox(
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red[900],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...cards,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FlyExpandTransition extends StatefulWidget {
  final Widget startChild;
  final Widget endChild;
  final Size endChildSize;
  final Offset origin;
  final Offset destination;
  final Size startChildStartSize;
  final Size startChildEndSize;
  final double startRotation;
  final double endRotation;
  final Size canvasSize;
  FlyExpandTransition(
      {required this.origin,
      required this.destination,
      required this.startChildStartSize,
      required this.startChildEndSize,
      required this.startRotation,
      required this.endRotation,
      required this.startChild,
      required this.endChild,
      required this.endChildSize,
      required this.canvasSize});

  @override
  _FlyExpandTransitionState createState() => _FlyExpandTransitionState();
}

class _FlyExpandTransitionState extends State<FlyExpandTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late final Tween<Size> _startChildSize;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _trailingChildrenOpacity;
  late final Animation<Size> _startChildSizeToEndChildSizeExpandAnimation;
  late final Animation<Size> _expnadedToEndChildSizeAnimation;
  late final Animation<double> _endChildOpacityAnimation;
  late final Animation<double> _pathAnimation;
  late final Path _path;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();

    _startChildSize = Tween<Size>(
      begin: widget.startChildStartSize,
      end: widget.startChildEndSize,
    );
    _rotationAnimation = Tween<double>(
      begin: widget.startRotation,
      end: widget.endRotation,
    ).animate(CurvedAnimation(
        parent: _animation, curve: Interval(0, 0.7, curve: Curves.linear)));

    _trailingChildrenOpacity = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animation,
      curve: Interval(0.65, 0.7, curve: Curves.easeOut),
    ));

    _startChildSizeToEndChildSizeExpandAnimation = Tween<Size>(
      begin: widget.startChildEndSize,
      end: Size(
          widget.endChildSize.width * 1.1, widget.endChildSize.height * 1.1),
    ).animate(CurvedAnimation(
      parent: _animation,
      curve: Interval(0.7, 0.9, curve: Curves.linear),
    ));

    _expnadedToEndChildSizeAnimation = Tween<Size>(
      begin: Size(
          widget.endChildSize.width * 1.1, widget.endChildSize.height * 1.1),
      end: widget.endChildSize,
    ).animate(CurvedAnimation(
      parent: _animation,
      curve: Interval(0.9, 1, curve: Curves.easeIn),
    ));

    _endChildOpacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animation,
      curve: Interval(0.95, 1, curve: Curves.linear),
    ));

    _pathAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animation,
      curve: Interval(0, 0.7, curve: Curves.linear),
    ));

    _path = drawPath();
  }

  Path drawPath() {
    Path path = Path();
    path.moveTo(widget.origin.dx, widget.origin.dy);
    path
      ..quadraticBezierTo(widget.destination.dx + 100, 0, widget.destination.dx,
          widget.destination.dy);
    return path;
  }

  Offset calculateOffset(value, lag) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    value = value - value * lag;
    Tangent pos = pathMetric.getTangentForOffset(value)!;
    return pos.position;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          List<Widget> phases = [];
          for (var x = 0; x <= 15; x++) {
            Offset offset = calculateOffset(_pathAnimation.value, x * 0.05);
            double height = _startChildSize.evaluate(_pathAnimation).height;
            double width = _startChildSize.evaluate(_pathAnimation).width;
            double rotation = _rotationAnimation.value;

            phases.add(Positioned(
                left: _animation.value >= 0.9
                    ? offset.dx -
                        _expnadedToEndChildSizeAnimation.value.width / 2
                    : _animation.value >= 0.7
                        ? offset.dx -
                            _startChildSizeToEndChildSizeExpandAnimation
                                    .value.width /
                                2
                        : offset.dx - width / 2,
                top: _animation.value >= 0.9
                    ? offset.dy -
                        _expnadedToEndChildSizeAnimation.value.height / 2
                    : _animation.value >= 0.7
                        ? offset.dy -
                            _startChildSizeToEndChildSizeExpandAnimation
                                    .value.height /
                                2
                        : offset.dy - height / 2,
                child: Transform.rotate(
                  angle: rotation - x * (pi / 2.5),
                  child: SizedBox(
                    height: _animation.value >= 0.9
                        ? _expnadedToEndChildSizeAnimation.value.height
                        : _animation.value >= 0.7
                            ? _startChildSizeToEndChildSizeExpandAnimation
                                .value.height
                            : height,
                    width: _animation.value >= 0.9
                        ? _expnadedToEndChildSizeAnimation.value.width
                        : _animation.value >= 0.7
                            ? _startChildSizeToEndChildSizeExpandAnimation
                                .value.width
                            : width,
                    child: Transform.scale(
                      scale: ((15 - (x * 1.3)) / 15).clamp(0, 1),
                      child: Opacity(
                        opacity: x == 0 ? 1 : _trailingChildrenOpacity.value,
                        child: Opacity(
                          opacity: ((15 - (x * 1.3)) / 15).clamp(0, 1),
                          child: widget.startChild,
                        ),
                      ),
                    ),
                  ),
                )));
          }
          Offset offset = calculateOffset(_pathAnimation.value, 0);
          phases.add(Positioned(
            top: offset.dy - widget.endChildSize.height / 2,
            left: offset.dx - widget.endChildSize.width / 2,
            child: SizedBox(
              height: widget.endChildSize.height,
              width: widget.endChildSize.width,
              child: Opacity(
                opacity: _endChildOpacityAnimation.value,
                child: widget.endChild,
              ),
            ),
          ));
          return SizedBox(
            height: widget.canvasSize.height,
            width: widget.canvasSize.width,
            child: Stack(
              children: phases,
            ),
          );
        });
  }
}

//calculate row and column from child count given the total row and column
int calculateRow(int childCount, int totalRow) {
  return (childCount / totalRow).floor();
}

int calculateColumn(int childCount, int totalRow) {
  return childCount % totalRow;
}

//get random materiColor from color array
MaterialColor getRandomMaterialColor() {
  List<MaterialColor> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.brown,
    Colors.amber,
    Colors.cyan,
    Colors.pink,
    Colors.lime,
    Colors.teal,
    Colors.indigo,
  ];
  return colors[Random().nextInt(colors.length)];
}
