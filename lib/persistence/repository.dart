import 'package:online_radio/model/now_playing_response_mode.dart';
import 'api_provider.dart';

class Repository {
  ApiProvider appApiProvider = ApiProvider();

  Future<NowNextPlayingResponse> getNowNextMadhSongs() =>
      appApiProvider.getNowNextMadhSongs();

  Future<NowNextPlayingResponse> getNowNextLiveSongs() =>
      appApiProvider.getNowNextLiveSongs();
}
