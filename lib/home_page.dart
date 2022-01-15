import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:online_radio/single_player.dart';
import 'main.dart';
import 'package:online_radio/bloc/nowNext_bloc.dart';
import 'package:online_radio/model/now_playing_response_mode.dart';

class HomePage extends StatelessWidget {
  final List<AudioPlayer> playerList;
  final List<BehaviorSubject> volumeSubjectList;
  final List<String> urlList;

  HomePage(this.playerList, this.volumeSubjectList, this.urlList);

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
          SinglePlayer(
            title: "Quran",
            playerMain: playerList[1],
            playerO1: playerList[0],
            playerO2: playerList[2],
            volumeSubject: volumeSubjectList[1],
            volumeStream: volumeSubjectList[1].stream,
            tabIndex: 2,
            mainUrl: urlList[1],
            typeStream: null,
          ),
          SinglePlayer(
            title: "Madh Songs",
            playerMain: playerList[2],
            playerO1: playerList[0],
            playerO2: playerList[1],
            volumeSubject: volumeSubjectList[1],
            volumeStream: volumeSubjectList[1].stream,
            tabIndex: 3,
            mainUrl: urlList[2],
            typeStream: "Madh",
          ),
          SizedBox(height: 40.0)
        ],
      ),
    ));
  }
}
