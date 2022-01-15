import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:online_radio/model/now_playing_response_mode.dart';

class ApiProvider {
  Client client1 = Client();
  final _baseUrl1 = "http://139.59.74.113/api/nowplaying/2";
  // final _baseUrl1 = "";

  Future<NowNextPlayingResponse> getNowNextMadhSongs() async {
    final response = await client1.get("$_baseUrl1");
    print(response.body.toString());

    if (response.statusCode == 200) {
      return NowNextPlayingResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  Client client2 = Client();
  final _baseUrl2 = "http://139.59.74.113/api/nowplaying/1";
  // final _baseUrl2 = "";

  Future<NowNextPlayingResponse> getNowNextLiveSongs() async {
    final response = await client2.get("$_baseUrl2");
    print(response.body.toString());

    if (response.statusCode == 200) {
      return NowNextPlayingResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load playlist');
    }
  }
}
