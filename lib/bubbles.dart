import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Bubbles extends StatefulWidget {
  final List<AudioPlayer> playerList;

  const Bubbles({Key key, this.playerList}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BubblesState(playerList);
  }
}

class _BubblesState extends State<Bubbles> with SingleTickerProviderStateMixin {
  final List<AudioPlayer> playerList;
  AnimationController _controller;
  List<Bubble> bubbles;
  final int numberOfBubbles = 500;
  final Color color = Colors.amber;
  final double maxBubbleSize = 4.0;

  _BubblesState(this.playerList);

  bool state1;
  bool state2;
  bool state3;

  @override
  void initState() {
    super.initState();

    state1 = false;
    state2 = false;
    state3 = false;
    // Initialize bubbles
    bubbles = List();
    int i = numberOfBubbles;
    while (i > 0) {
      bubbles.add(Bubble(color, maxBubbleSize, 0.1));
      i--;
    }

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(seconds: 1000), vsync: this);
    _controller.addListener(() {
      updateBubblePosition();
    });
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      StreamBuilder<FullAudioPlaybackState>(
          stream: playerList[0].fullPlaybackStateStream,
          builder: (context, snapshot) {
            final fullState = snapshot.data;
            final state = fullState?.state;
            if (state == AudioPlaybackState.playing) {
              state1 = true;
              _controller.forward();
            } else
              state1 = false;

            if (!(state1 || state2 || state3)) {
              _controller.stop();
              print("OFF " +
                  state1.toString() +
                  " " +
                  state2.toString() +
                  " " +
                  state3.toString());
            }
            return Container();
          }),
      StreamBuilder<FullAudioPlaybackState>(
          stream: playerList[1].fullPlaybackStateStream,
          builder: (context, snapshot) {
            final fullState = snapshot.data;
            final state = fullState?.state;
            if (state == AudioPlaybackState.playing) {
              state2 = true;
              _controller.forward();
              print("ON " +
                  state1.toString() +
                  " " +
                  state2.toString() +
                  " " +
                  state3.toString());
            } else
              state2 = false;

            if (!(state1 || state2 || state3)) {
              _controller.stop();
              print("OFF " +
                  state1.toString() +
                  " " +
                  state2.toString() +
                  " " +
                  state3.toString());
            }

            return Container();
          }),
      StreamBuilder<FullAudioPlaybackState>(
          stream: playerList[2].fullPlaybackStateStream,
          builder: (context, snapshot) {
            final fullState = snapshot.data;
            final state = fullState?.state;
            if (state == AudioPlaybackState.playing) {
              state3 = true;
              _controller.forward();
            } else
              state3 = false;

            if (!(state1 || state2 || state3)) {
              _controller.stop();
              print("OFF " +
                  state1.toString() +
                  " " +
                  state2.toString() +
                  " " +
                  state3.toString());
            }

            return Container();
          }),
      CustomPaint(
        foregroundPainter:
            BubblePainter(bubbles: bubbles, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
      ),
    ]));
  }

  void updateBubblePosition() {
    bubbles.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class BubblePainter extends CustomPainter {
  List<Bubble> bubbles;
  AnimationController controller;

  BubblePainter({this.bubbles, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    bubbles.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Bubble(Color colour, double maxBubbleSize, double spee) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = Random().nextDouble() * 360;
    this.speed = spee;
    this.radius = Random().nextDouble() * maxBubbleSize;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);

    randomlyChangeDirectionIfEdgeReached(canvasSize);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
      this.x = Random().nextDouble() * canvasSize.width;
    }

    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height;
    }
  }

  updatePosition() {
    var a = 180 - (direction + 90);
    direction > 0 && direction < 180
        ? x += speed * sin(direction) / sin(speed)
        : x -= speed * sin(direction) / sin(speed);
    direction > 90 && direction < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
  }

  randomlyChangeDirectionIfEdgeReached(Size canvasSize) {
    if (x > canvasSize.width || x < 0 || y > canvasSize.height || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }
}
