import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:online_radio/single_player.dart';
import 'package:online_radio/bloc/nowNext_bloc.dart';
import 'package:online_radio/model/now_playing_response_mode.dart';

class LivePage extends StatelessWidget {
  final List<AudioPlayer> playerList;
  final List<BehaviorSubject> volumeSubjectList;
  final List<String> urlList;

  LivePage(this.playerList, this.volumeSubjectList, this.urlList);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blueGrey.shade900,
        child: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          SinglePlayer(
            title: "Live",
            playerMain: playerList[0],
            playerO1: playerList[1],
            playerO2: playerList[2],
            volumeSubject: volumeSubjectList[0],
            volumeStream: volumeSubjectList[0].stream,
            tabIndex: 1,
            mainUrl: urlList[0],
            typeStream: "Live",
          ),
        ],
      ),
    ));
  }
}
