import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:videoapp/utils/Model.dart';
import 'package:videoapp/utils/Videos.dart';
import 'package:videoapp/utils/CircleAnimation.dart';

class Home extends StatefulWidget  {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool first = true;
  int previousindex = 0;
  bool ispause = false;
  VideoPlayerController currentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{

        try {
          Navigator.maybePop(context);
          currentController.pause();
        }
        catch(e)
        {

        }
        return true;
      },
      child: Material(
        child: Stack(
          children: [
            PageView.builder(
              controller: PageController(
                initialPage: 0,
                viewportFraction: 1,
              ),
              itemCount: Videos.getCounts(),
              onPageChanged: (index) {
                index = index % Videos.getCounts();

                print("change $index");
                changeVideo(index);
                //feedViewModel.changeVideo(index);
              },
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                index = index % Videos.getCounts();
                return VideoItems(Videos.getVideos()[index]);
              },
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Following',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white70)),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        color: Colors.white70,
                        height: 10,
                        width: 1.0,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text('For You',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {


    super.dispose();
  }

  Future<void> changeVideo(index) async {
    try {
      setState(() {
        ispause = false;
      });
    } catch (e) {}
    if (!first) Videos.videos[previousindex].controller.pause();

    if (Videos.videos[index].controller == null) {
      await Videos.videos[index].setController(true);
      Videos.videos[index].controller.play();
    } else {
      if(!Videos.videos[index].controller.value.initialized)
        {
          Videos.videos[index].setInit(true);
        }
      else {
        Videos.videos[index].controller.play();
      }
    }
    if (index < Videos.videos.length - 1) {
      if (Videos.videos[index + 1].controller == null) {
        await Videos.videos[index + 1].setController(false);
      }
    }
    currentController=Videos.videos[index].controller;
    previousindex = index;
    try {
      first = false;
      setState(() {

      });
    }
    catch(e)
    {

    }
  }


  Widget VideoItems(Model video) {
    if (first) {
      changeVideo(0);
    }
    return Stack(
      children: [
        video.controller != null && video.controller.value.initialized
            ? GestureDetector(
                onTap: () {
                  if (video.controller.value.isPlaying) {
                    video.controller.pause();
                  } else {
                    video.controller.play();
                  }

                  setState(() {
                    ispause = !ispause;
                  });
                },
                child: SizedBox.expand(
                    child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: video.controller.value.size?.width ?? 0,
                    height: video.controller.value.size?.height ?? 0,
                    child: VideoPlayer(video.controller),
                  ),
                )),
              )
            : Container(
                color: Colors.black,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitCircle(
                        color: Colors.red,
                      ),
                      Text(
                        "Loading..",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            actionBtns(video),
            videoDes(video),
          ],
        ),
        Visibility(
          visible: ispause,
          child: SizedBox.expand(
              child: Center(
            child: IconButton(
              icon: Icon(Icons.play_arrow_rounded, size: 80),
              onPressed: () {
                video.controller.play();
                setState(() {
                  ispause = !ispause;
                });
              },
            ),
          )),
        ),
      ],
    );
  }

  Widget actionBtns(Model video) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(right: 15.0),
            child: Column(children: [
              Icon(
                Icons.favorite,
                color: Colors.white,
                size: 35,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(video.likes,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
              ),
              SizedBox(
                height: 20,
              ),
              Icon(
                Icons.comment,
                color: Colors.white,
                size: 35,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(video.comments,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
              ),
              SizedBox(
                height: 20,
              ),
              Icon(
                Icons.share,
                color: Colors.white,
                size: 35,
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(video.shares,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
              ),
              SizedBox(
                height: 20,
              ),
            ]))
      ],
    );
  }

  Widget videoDes(Model video) {
    return Container(
        color: Colors.black.withOpacity(0.20),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "@ ${video.name}",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      video.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(children: [
                      Icon(
                        Icons.music_note,
                        size: 15.0,
                        color: Colors.white,
                      ),
                      Text("Song Text",
                          style: TextStyle(color: Colors.white, fontSize: 14.0))
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
            ),
            SizedBox(
              width: 5,
            ),
            CircleImageAnimation(
              child: profilePic(video.headshot),
            ),
          ],
        ));
  }

  Widget profilePic(userPic) {
    double size = 60;
    return Container(
        padding: EdgeInsets.all(5.0),
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(size / 2)),
        // import 'package:cached_network_image/cached_network_image.dart'; at the top to use CachedNetworkImage
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: CachedNetworkImage(
              imageUrl: userPic,
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            )));
  }
}
