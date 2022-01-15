import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class MySlider extends StatelessWidget {
  final AudioPlayer player;
  final BehaviorSubject volumeSubject;

  const MySlider({Key key, @required this.player, @required this.volumeSubject})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: player.playerVolumeStream,
        builder: (context, snapshot) {
          final double fullState = snapshot.data;
          print("ABU " + fullState.toString());

          return FlutterSlider(
            tooltip: FlutterSliderTooltip(
              // alwaysShowTooltip: false,
              boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900 // Colors.white
                      ,
                      shape: BoxShape.circle)),
              textStyle: TextStyle(fontSize: 10, color: Colors.white),
            ),
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBar:
                  BoxDecoration(color: Colors.blueGrey.shade900 // Colors.white,
                      ),
              activeTrackBar: BoxDecoration(color: Colors.blue),
            ),
            handler: FlutterSliderHandler(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),

              child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    player.volume != 0 ? Icons.volume_up : Icons.volume_mute,
                    // player.mycon,
                    size: 25,
                  )),
              // ),
            ),
            axis: Axis.vertical,
            values: [player.volume * 100 ?? 100],
            rtl: true,
            max: 100,
            min: 0,
            onDragging: (handlerIndex, snapshot, upperValue) {
              // print("l- " + snapshot.toString());
              double value = (double.parse(snapshot.toString()) / 100);
              // print("object " + player.volume.toString());

              volumeSubject.add(value);
              player.setVolume(value);

              // print(player.volume.toString());
            },
          );
        });
    // });
  }
}
