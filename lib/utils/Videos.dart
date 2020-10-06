import 'Model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Videos {
  static List<Model> videos = [];

  // it load all data from api
  static Future<bool> loadVideos() async {
    var url = 'https://www.pinkvilla.com/feed/video-test/video-feed.json';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      for (Map i in jsonResponse) {
        videos.add(Model.fromJson(i));
      }
      return true;
    } else {
      return false;
    }
  }


  static int getCounts()
  {
    return videos.length;
  }

  static List<Model> getVideos() {
    return videos;
  }
}
