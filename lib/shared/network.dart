import 'package:flutter_ui_music_player/model/song_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const url = 'http://3.6.166.16:3100/api/v1/app/';

class networkHelper {
  static List<Song> songlist = [];
  static String cat = "kuchbhi";

  Future getsongs(int start, String kselcatgry) async {
    if (cat != kselcatgry) {
      songlist.clear();
      cat = kselcatgry;
    }
    try {
      var res = await http.post(
        url + 'get-all-song',
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body: json.encode(<String, dynamic>{
          'limit': 10,
          'offset': start,
          'song_type': kselcatgry
        }),
      );
      var sl = jsonDecode(res.body)['data']['Song'];
      for (var sn in sl) {
        songlist.add(
            Song(title: sn['title'], duration: sn['duration'], id: sn['id']));
      }
//      return songlist.sublist(start);
      return songlist;
    } catch (e) {
      print(e);
    }
  }

  Future getsongdetail(String id) async {
    var res = await http.post(
      url + 'get-url',
      headers: {"Content-Type": "application/json;charset=utf-8"},
      body: json.encode(<String, dynamic>{"song_id": id}),
    );
    var decodeddata = jsonDecode(res.body);
    return decodeddata['data']['URL'];
  }
}
