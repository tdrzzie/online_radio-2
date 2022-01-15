import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:rxdart/rxdart.dart';
import 'package:online_radio/my_slider.dart';
import 'package:online_radio/scrolling_text.dart';
import 'main.dart';

import 'package:intl/intl.dart';

import 'package:online_radio/bloc/nowNext_bloc.dart';
import 'package:online_radio/model/now_playing_response_mode.dart';

class SinglePlayer extends StatelessWidget {
  final String title;
  final AudioPlayer playerMain;
  final String mainUrl;
  final AudioPlayer playerO1;
  final AudioPlayer playerO2;

  final BehaviorSubject volumeSubject;
  final Stream<dynamic> volumeStream;

  final int tabIndex;

  final String typeStream;

  const SinglePlayer(
      {Key key,
      @required this.volumeSubject,
      @required this.playerMain,
      @required this.mainUrl,
      @required this.playerO1,
      @required this.playerO2,
      @required this.volumeStream,
      @required this.title,
      @required this.tabIndex,
      this.typeStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    nowNextMadhBloc.getNowNextMadhSongs();
    nowNextLiveBloc.getNowNextLiveSongs();

    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // shrinkWrap: true,
            children: [
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
              color: Colors.blueGrey.shade900, // Colors.white
            ),
          )),
          typeStream != null
              ? Container(
                  width: 200.0,
                  height: 20.0,
                  child: StreamBuilder(
                      stream: typeStream == "Live"
                          ? nowNextLiveBloc.nowNextLiveSong
                          : nowNextMadhBloc.nowNextMadhSong,
                      builder: (context,
                          AsyncSnapshot<NowNextPlayingResponse> snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                              child: Container(
                                  width: 200.0,
                                  height: 16.0,
                                  child: Marquee(
                                    text: "Now: " +
                                        snapshot.data.nowPlaying.song.title
                                            .toString() +
                                        " || Next: " +
                                        snapshot.data.nextPlaying.song.title
                                            .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.blueGrey.shade900,
                                      // Colors.white
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    blankSpace: 20.0,
                                    velocity: 100.0,
                                    pauseAfterRound: Duration(seconds: 1),
                                    startPadding: 10.0,
                                    accelerationDuration: Duration(seconds: 1),
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration:
                                        Duration(milliseconds: 500),
                                    decelerationCurve: Curves.easeOut,
                                    // textAlign: TextAlign.center,
                                  )));
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return Center(child: Container());
                      }))
              : Container(),

          Center(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                Container(
                    width: 100.0,
                    height: 200.0,
                    child: StreamBuilder<FullAudioPlaybackState>(
                        stream: playerMain.fullPlaybackStateStream,
                        builder: (context, snapshot) {
                          final fullState = snapshot.data;
                          final state = fullState?.state;
                          final buffering = fullState?.buffering;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  color: Colors.blue,
                                  splashColor: Colors.orange,
                                  icon: Icon(
                                    Icons.refresh,
                                  ),
                                  iconSize: 64.0,
                                  onPressed: () {
                                    if (!(state ==
                                            AudioPlaybackState.stopped) ||
                                        (state == AudioPlaybackState.none) ||
                                        (state ==
                                            AudioPlaybackState.connecting) ||
                                        (buffering == true))
                                      playerMain.setUrl(mainUrl.toString());
                                  }),
                              IconButton(
                                color: Colors.blue,
                                splashColor: Colors.orange,
                                icon: Icon(
                                  Icons.stop,
                                ),
                                iconSize: 32.0,
                                onPressed:
                                    state == AudioPlaybackState.stopped ||
                                            state == AudioPlaybackState.none ||
                                            state ==
                                                AudioPlaybackState.connecting ||
                                            buffering == true
                                        ? null
                                        : playerMain.stop,
                              ),
                            ],
                          );
                        })),
                StreamBuilder<FullAudioPlaybackState>(
                  stream: playerMain.fullPlaybackStateStream,
                  builder: (context, snapshot) {
                    final fullState = snapshot.data;
                    final state = fullState?.state;
                    final buffering = fullState?.buffering;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state == AudioPlaybackState.connecting ||
                            buffering == true)
                          Container(
                            margin: EdgeInsets.all(8.0),
                            width: 100.0,
                            height: 100.0,
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  Colors.blueGrey.shade900, //Colors.white,
                              strokeWidth: 5.0,
                            ),
                          )
                        else if (state == AudioPlaybackState.playing)
                          IconButton(
                            icon: Icon(Icons.pause_circle_outline),
                            color: Colors.blueGrey.shade900, //Colors.white,
                            iconSize: 120.0,
                            onPressed: playerMain.pause,
                          )
                        else
                          IconButton(
                            icon: Icon(Icons.play_circle_outline),
                            color: Colors.blueGrey.shade900, //Colors.white,
                            iconSize: 120.0,
                            onPressed: () {
                              playerMain.play();

                              MyApp.of(context)
                                  .tabController
                                  .animateTo(tabIndex);

                              if (playerO1 != null) if (playerO1
                                      .playbackState ==
                                  AudioPlaybackState.playing) playerO1.pause();

                              if (playerO2 != null) if (playerO2
                                      .playbackState ==
                                  AudioPlaybackState.playing) playerO2.pause();
                            },
                          ),
                      ],
                    );
                  },
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  child: Center(
                      child: StreamBuilder<double>(
                          stream: volumeStream,
                          builder: (context, snapshot) => MySlider(
                                player: playerMain,
                                volumeSubject: volumeSubject,
                              ))),
                ),
              ])),
          // showNowNext
          //     ? Center(
          //         child: Text(
          //         "Next:",
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16.0,
          //           color: Colors.blue, // Colors.white
          //         ),
          //       ))
          //     : Container(),
          // showNowNext
          //     ? StreamBuilder(
          //         stream: nowNextBloc.nowNextSong,
          //         builder:
          //             (context, AsyncSnapshot<NowPlayingResponse> snapshot) {
          //           if (snapshot.hasData) {
          //             return Center(
          //                 child: Container(
          //                     width: 200.0,
          //                     height: 30.0,
          //                     child: Text(
          //                       snapshot.data.nextPlaying.song.title,
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 14.0,
          //                         color:
          //                             Colors.blueGrey.shade900, // Colors.white
          //                       ),
          //                       textAlign: TextAlign.center,
          //                     )));
          //           } else if (snapshot.hasError) {
          //             return Text(snapshot.error.toString());
          //           }
          //           return Center(child: Container());
          //         })
          //     : Container(),
        ]));
  }
}
