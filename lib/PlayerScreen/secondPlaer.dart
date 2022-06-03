import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parser_flutter/helper/SQLHelper.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class BetterPlayerPactice extends StatefulWidget {
  var link;

  BetterPlayerPactice(this.link, {Key? key}) : super(key: key);

  @override
  State<BetterPlayerPactice> createState() =>
      _BetterPlayerPacticeState(this.link);
}

class _BetterPlayerPacticeState extends State<BetterPlayerPactice> {
  late BetterPlayerController _betterPlayerController;
  var link;
  _BetterPlayerPacticeState(this.link);
  late List<Map<String, dynamic>> _allChannelList = [];

  getAllChannelFromSqlite() async {
    final data = await SQLHelper.getAllItems();
    setState(() {
      _allChannelList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, this.link);
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);
    setState(() {
      _betterPlayerController.play();
    });
    getAllChannelFromSqlite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live TV"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: BetterPlayer(
                          controller: _betterPlayerController,
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: _allChannelList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    _betterPlayerController.dispose();
                    BetterPlayerDataSource betterPlayerDataSource =
                    BetterPlayerDataSource(BetterPlayerDataSourceType.network, _allChannelList[index]['link']);
                    _betterPlayerController = BetterPlayerController(
                        BetterPlayerConfiguration(),
                        betterPlayerDataSource: betterPlayerDataSource);
                    setState(() {
                      _betterPlayerController.play();
                    });
                  },
                  title: Text(_allChannelList[index]['title'].toString()),
                  trailing: _allChannelList[index]['logo'].toString().isNotEmpty
                      ? Image.network(_allChannelList[index]['logo'])
                      : Icon(Icons.tv),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
  }
}
