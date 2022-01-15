import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:online_radio/single_player.dart';
import 'package:online_radio/bloc/nowNext_bloc.dart';
import 'package:online_radio/model/now_playing_response_mode.dart';

class MadhPage extends StatelessWidget {
  final List<AudioPlayer> playerList;
  final List<BehaviorSubject> volumeSubjectList;
  final List<String> urlList;

  MadhPage(this.playerList, this.volumeSubjectList, this.urlList);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blueGrey.shade900,
        child: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          SinglePlayer(
            title: "Madh Songs",
            playerMain: playerList[2],
            playerO1: playerList[0],
            playerO2: playerList[1],
            volumeSubject: volumeSubjectList[2],
            volumeStream: volumeSubjectList[2].stream,
            tabIndex: 3,
            mainUrl: urlList[2],
            typeStream: "Madh",
          ),
        ],
      ),
    ));
  }
}
