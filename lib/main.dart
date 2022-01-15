import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:online_radio/home_page.dart';
import 'package:online_radio/live_page.dart';
import 'package:online_radio/quran_page.dart';
import 'package:online_radio/madh_page.dart';

import 'package:just_audio/just_audio.dart';
import 'package:online_radio/waves.dart';
import 'package:rxdart/rxdart.dart';

import 'package:online_radio/bubbles.dart';
import 'package:online_radio/customTab.dart';
import 'package:online_radio/bloc/nowNext_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final myTabbedPageKey = new GlobalKey<_MyAppState>();

  final _volumeSubject1 = BehaviorSubject.seeded(1.0);
  AudioPlayer _player1;
  String _player1Url = "http://139.59.74.113/radio/8000/radio.mp3";

  final _volumeSubject2 = BehaviorSubject.seeded(1.0);
  AudioPlayer _player2;
  String _player2Url = "http://archive.org/download/Mishary-Alafasy/002.mp3";

  final _volumeSubject3 = BehaviorSubject.seeded(1.0);
  AudioPlayer _player3;
  String _player3Url = "http://139.59.74.113/radio/8010/radio.mp3";

  List<AudioPlayer> playerList = new List();
  List<BehaviorSubject> volumeSubjectList = new List();
  List<String> urlList = new List();

  TabController tabController;

  Timer timer;

  @override
  void initState() {
    super.initState();
    _player1 = AudioPlayer();
    _player1.setUrl(_player1Url);

    _player2 = AudioPlayer();
    _player2.setUrl(_player2Url);

    _player3 = AudioPlayer();
    _player3.setUrl(_player3Url);

    playerList = [_player1, _player2, _player3];
    volumeSubjectList = [_volumeSubject1, _volumeSubject2, _volumeSubject3];
    urlList = [_player1Url, _player2Url, _player3Url];

    tabController = new TabController(vsync: this, length: 4);
    timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => chekAzuraCastApi());
  }

  @override
  void dispose() {
    _player1.dispose();
    _player2.dispose();
    _player3.dispose();
    tabController.dispose();
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Radio',
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        key: myTabbedPageKey,
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Online Radio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
              backgroundColor: Colors.blueGrey.shade900,
              centerTitle: true,
              bottom: TabBar(
                indicator: CustomTabIndicator(),
                controller: tabController,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(
                    text: "Live",
                  ),
                  Tab(
                    text: "Quran",
                  ),
                  Tab(
                    text: "Madh",
                  ),
                ],
              ),
            ),
            body: Stack(children: <Widget>[
              Waves(
                playerList: playerList,
              ),
              // Bubbles(
              //   playerList: playerList,
              // ),
              TabBarView(
                controller: tabController,
                children: [
                  HomePage(playerList, volumeSubjectList, urlList),
                  LivePage(playerList, volumeSubjectList, urlList),
                  QuranPage(playerList, volumeSubjectList, urlList),
                  MadhPage(playerList, volumeSubjectList, urlList)
                ],
              )
            ])),
      ),
    );
  }
}

Future<http.Response> chekAzuraCastApi() {
  nowNextMadhBloc.getNowNextMadhSongs();
  nowNextLiveBloc.getNowNextLiveSongs();
}

// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
