import 'package:video_player/video_player.dart';

class Model
{

  String title;
  String name,headshot;
  String shares;
  String likes;
  String comments;
  String videourl;

  VideoPlayerController controller=null;

  Model.fromJson(Map<dynamic, dynamic> json) {


    title = json['title'];
    likes = json['like-count'].toString();
    comments = json['comment-count'].toString();
    shares=json["share-count"].toString();
    videourl = json['url'];
    Map<dynamic, dynamic> temp=json["user"];
    name = temp['name'];
    headshot=temp["headshot"];

    print("Video :  ${videourl}");

    // setController();
  }
  Future<Null> setController(bool play) async {
    controller = VideoPlayerController.network(videourl);
    await controller.initialize();

    controller.setLooping(true);
    if(play)
    await controller.play();
  }
  Future<Null> setInit(bool play) async {
    try {
      await controller.initialize();
      controller.setLooping(true);
      if (play)
        await controller.play();
    }
    catch(e)
    {

    }
  }


}