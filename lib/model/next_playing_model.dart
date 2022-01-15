import 'package:online_radio/model/song_model.dart';

class NextPlaying {
  // int sh_id;
  // int played_at;
  // int duration;
  // String playlist;
  // String streamer;
  // bool is_request;
  Song song;

  NextPlaying(parsedJson) {
    // sh_id = parsedJson['sh_id'];
    // played_at = parsedJson['played_at'];
    // duration = parsedJson['duration'];
    // playlist = parsedJson['playlist'];
    // streamer = parsedJson['streamer'];
    // is_request = parsedJson['is_request'];
    song = Song(parsedJson['song']);
  }
}
