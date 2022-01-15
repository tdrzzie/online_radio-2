import 'package:online_radio/model/song_model.dart';

class NowPlaying {
  // int elapsed;
  // int remaining;
  // int sh_id;
  // int played_at;
  // int duration;
  // String playlist;
  // String streamer;
  // bool is_request;
  Song song;

  NowPlaying(parsedJson) {
    // elapsed = parsedJson['elapsed'];
    // remaining = parsedJson['remaining'];
    // sh_id = parsedJson['sh_id'];
    // played_at = parsedJson['played_at'];
    // duration = parsedJson['duration'];
    // playlist = parsedJson['playlist'];
    // streamer = parsedJson['streamer'];
    // is_request = parsedJson['is_request'];
    song = Song(parsedJson['song']);
  }
}
