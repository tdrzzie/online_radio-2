import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:online_radio/single_player.dart';

class QuranPage extends StatelessWidget {
  final List<AudioPlayer> playerList;
  final List<BehaviorSubject> volumeSubjectList;
  final List<String> urlList;

  QuranPage(this.playerList, this.volumeSubjectList, this.urlList);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blueGrey.shade900,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
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
            ],
          ),
        ));
  }
}
