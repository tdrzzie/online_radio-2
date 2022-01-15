import 'dart:math';
import 'dart:ui' as ui;
import 'package:just_audio/just_audio.dart';
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Waves extends StatefulWidget {
  final List<AudioPlayer> playerList;

  Waves({Key key, this.playerList}) : super(key: key) {
    timeDilation = 1.0;
  }

  @override
  _WavesState createState() => new _WavesState(playerList);
}

class _WavesState extends State<Waves> {
  final List<AudioPlayer> playerList;

  _WavesState(this.playerList);

  @override
  Widget build(BuildContext context) {
    Size size = new Size(MediaQuery.of(context).size.width, 100.0);
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          Positioned(
              bottom: 0.0,
              child: new Opacity(
                opacity: 0.6,
                child: new DemoBody(
                  size: size,
                  xOffset: 0,
                  yOffset: 0,
                  color: Colors.blue,
                  playerList: playerList,
                ),
              )),
          Positioned(
            bottom: 0.0,
            child: new Opacity(
              opacity: 0.3,
              child: new DemoBody(
                  size: size,
                  xOffset: 50,
                  yOffset: 10,
                  color: Colors.blue,
                  playerList: playerList),
            ),
          )
        ],
      ),
    );
  }
}

class DemoBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;
  final List<AudioPlayer> playerList;

  DemoBody(
      {Key key,
      @required this.size,
      this.xOffset,
      this.yOffset,
      this.color,
      this.playerList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DemoBodyState(playerList);
  }
}

class _DemoBodyState extends State<DemoBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  final List<AudioPlayer> playerList;

  _DemoBodyState(this.playerList);

  bool state1;
  bool state2;
  bool state3;

  @override
  void initState() {
    super.initState();
    state1 = false;
    state2 = false;
    state3 = false;

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.size.width.toInt() + 2;
          i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                        360 *
                        Vector.degrees2Radians) *
                    20 +
                50 +
                widget.yOffset));
      }
    });
    // animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      StreamBuilder<FullAudioPlaybackState>(
          stream: playerList[0].fullPlaybackStateStream,
          builder: (context, snapshot) {
            final fullState = snapshot.data;
            final state = fullState?.state;
            if (state == AudioPlaybackState.playing) {
              state1 = true;
              animationController.repeat();
            } else
              state1 = false;

            if (!(state1 || state2 || state3)) {
              animationController.forward();
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
              animationController.repeat();
              print("ON " +
                  state1.toString() +
                  " " +
                  state2.toString() +
                  " " +
                  state3.toString());
            } else
              state2 = false;

            if (!(state1 || state2 || state3)) {
              animationController.forward();
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
              animationController.repeat();
            } else
              state3 = false;

            if (!(state1 || state2 || state3)) {
              animationController.forward();
              print("OFF " +
                  state1.toString() +
                  " " +
                  state2.toString() +
                  " " +
                  state3.toString());
            }

            return Container();
          }),
      new Container(
        alignment: Alignment.center,
        child: new AnimatedBuilder(
          animation: new CurvedAnimation(
            parent: animationController,
            curve: Curves.easeInOut,
          ),
          builder: (context, child) => new ClipPath(
            child: new Container(
              width: widget.size.width,
              height: widget.size.height,
              color: widget.color,
            ),
            clipper: new WaveClipper(animationController.value, animList1),
          ),
        ),
      )
    ]);
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
