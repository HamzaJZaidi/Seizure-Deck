import 'package:flutter/material.dart';
import 'package:seizure_deck/data/instructions.dart';
import 'package:seizure_deck/database/instructionDB.dart';
import 'package:seizure_deck/screens/home_screen/webpage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Instructions> resourceLinks = [];

  @override
  void initState() {
    super.initState();
    // fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: const Text("Instruction List",style: TextStyle(color: Colors.white),),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
      ),
      body: Center(
          child: FirstAidList()),
    );
  }

}

Widget FirstAidList() {
  return FutureBuilder(
    future: fetchLinks(),
    builder:
        (BuildContext context, AsyncSnapshot<List<Instructions>> snapshot) {
      List<Instructions> instData = snapshot.data!;
      return ListBuild(context, instData);
    },
  );
}

Widget ListBuild(BuildContext context, List<Instructions> userInstruction) {
  return ListView.builder(
      itemCount: userInstruction.length,
      itemBuilder: (context, index) {
        Instructions inst = userInstruction[index];
        return InstructionsListTile(context, inst);
      });
}

Widget InstructionsListTile(BuildContext context, Instructions inst) {
  if (inst.url.contains("youtube")) {
    return Card(
      elevation: 40,
      shadowColor: Color(0xFF454587),
      child: Column(
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(inst.url) ?? '',
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            ),
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            aspectRatio: 16 / 9,
          ),
          Text(inst.title, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),)
        ],
      ),
    );
  } else {
    WebViewController controller;
    Uri url = Uri.parse(inst.url);
    controller = WebViewController()
      ..loadRequest(url);
    return GestureDetector(
        child: Card(
          elevation: 40,
          shadowColor: Color(0xFF454587),
          child: Container(
            height: 50,
            child: Center(
              child: Text(inst.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,color: Colors.blue,
                  decoration: TextDecoration.underline,),),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => webpage(url: inst.url)));
        });
  }
}
