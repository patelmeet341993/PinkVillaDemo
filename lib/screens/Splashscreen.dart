import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:videoapp/utils/Videos.dart';

class Splashscreen extends StatefulWidget {

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {


  bool iserror=false;

  @override
  void initState() {
    super.initState();

      Future<bool> isvideoready=Videos.loadVideos();
      isvideoready.then((value){
        print("load successfully");
        if(!value){
          setState(() {
            iserror=true;
          });
        }
        else {
          Navigator.popAndPushNamed(context, "/home");
        }
    });

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset("assets/logo.png"),
                  ),
                  SizedBox(height: 20,),
                  iserror?Text("Please try after sometime"):SpinKitRing(color: Colors.red,)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
