import 'package:rxdart/rxdart.dart';
import 'package:online_radio/model/now_playing_response_mode.dart';
import 'package:online_radio/persistence/repository.dart';

class NowNextMadhBloc {
  Repository _repository = Repository();

  final _nowNextFetcher = PublishSubject<NowNextPlayingResponse>();

  Stream<NowNextPlayingResponse> get nowNextMadhSong => _nowNextFetcher.stream;

  getNowNextMadhSongs() async {
    NowNextPlayingResponse nowPlayingResponse =
        await _repository.getNowNextMadhSongs();
    _nowNextFetcher.sink.add(nowPlayingResponse);
  }

  dispose() {
    _nowNextFetcher.close();
  }
}

final nowNextMadhBloc = NowNextMadhBloc();



class NowNextLiveBloc {
  Repository _repository = Repository();

  final _nowNextFetcher = PublishSubject<NowNextPlayingResponse>();

  Stream<NowNextPlayingResponse> get nowNextLiveSong => _nowNextFetcher.stream;

  getNowNextLiveSongs() async {
    NowNextPlayingResponse nowPlayingResponse =
        await _repository.getNowNextLiveSongs();
    _nowNextFetcher.sink.add(nowPlayingResponse);
  }

  dispose() {
    _nowNextFetcher.close();
  }
}

final nowNextLiveBloc = NowNextLiveBloc();
