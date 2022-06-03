import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:parser_flutter/UserController.dart';
import 'package:parser_flutter/bottom_nav_bar.dart';
import 'package:parser_flutter/getFileFromStorage.dart';
import 'package:parser_flutter/singleList.dart';

import 'helper/SQLHelper.dart';

class PlayListTest extends StatefulWidget {
  const PlayListTest({Key? key}) : super(key: key);

  @override
  State<PlayListTest> createState() => _PlayListTestState();
}

class _PlayListTestState extends State<PlayListTest> {
  List<Map<String, dynamic>> _list = [];
  int _selectedIndex = 0;
  UserControler controler = Get.put(UserControler());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshChannelList();
  }

  void _refreshChannelList() async {
    final data = await SQLHelper.getAllPlayList();
    setState(() {
      _list = data;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _bottomClickHandle();
    });
  }

  void _bottomClickHandle() {
    switch (_selectedIndex) {
      case 0:
        Get.to((PlayListTest()));
        print("pos 0");
        break;
      case 1:
        Get.to(GetFileFromStorage());
        print("pos 1");
        break;
      case 2:
        print("pos 2");
        //   Get.to(FilePickerFromStorage());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onClicked: _onItemTapped,
      ),
      appBar: AppBar(
        title: Text("m3u8"),
      ),
      body: Center(
        child: Expanded(
          child: _list.isNotEmpty
              ? ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[400],
                      elevation: 4,
                      child: ListTile(
                          onTap: () =>
                              {controler.getSigleList(_list[index]['title'])},
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.grey))),
                            child: Icon(Icons.autorenew, color: Colors.grey),
                          ),
                          title: Text(
                            _list[index]['title'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                          subtitle: Row(
                            children: <Widget>[
                              Icon(Icons.linear_scale,
                                  color: Colors.yellowAccent),
                              Text("ddd", style: TextStyle(color: Colors.white))
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.grey, size: 30.0)),
                    );
                  })
              : const Text(
                  'No PlayList found \n Add Playlist First',
                  style: TextStyle(fontSize: 24),
                ),
        ),
      ),
    );
  }
}
