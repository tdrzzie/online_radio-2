import 'package:online_radio/model/song_model.dart';
import 'package:online_radio/model/now_playing_model.dart';
import 'package:online_radio/model/next_playing_model.dart';

class NowNextPlayingResponse {
  NowPlaying nowPlaying;
  NextPlaying nextPlaying;

  NowNextPlayingResponse.fromJson(Map<String, dynamic> parsedJson) {
    nowPlaying = NowPlaying(parsedJson['now_playing']);
    nextPlaying = NextPlaying(parsedJson['playing_next']);
  }
}
