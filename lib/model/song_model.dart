class Song {
  String id;
  String text;
  String artist;
  String title;
  String album;
  String lyrics;
  String art;

  Song(parsedJson) {
    id = parsedJson['id'];
    text = parsedJson['text'];
    artist = parsedJson['artist'];
    title = parsedJson['title'];
    album = parsedJson['album'];
    lyrics = parsedJson['lyrics'];
    art = parsedJson['art'];
  }
}
