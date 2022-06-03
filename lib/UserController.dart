import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:parser_flutter/singleList.dart';

import 'helper/SQLHelper.dart';

class UserControler extends GetxController with StateMixin<List<dynamic>> {
  var link = "ii".obs;

  List<Map<String, dynamic>> _allChannelList = [];
  List<Map<String, dynamic>> _list = [];
  List<Map<String, dynamic>> _singleList = [];

  @override
  void onInit() {
    _getPlayList();
    _getAllChannelList();
  }

  void _getPlayList() async {
    final data = await SQLHelper.getAllPlayList();
    _list = data;
  }

  void _getAllChannelList() async {
    final data = await SQLHelper.getAllItems();
    _allChannelList = data;
  }

  getSigleList(String cat) async {
    final data = await SQLHelper.getItemByCategory(cat);
    _singleList = data;
    if (_singleList.isNotEmpty) {
      Get.to(SingleList(_singleList));
    }
  }

  List<Map<String, dynamic>> get singleList => _singleList;
  List<Map<String, dynamic>> get allChannelList => _allChannelList;

  @override
  void onReady() {
    _getPlayList();
    _getAllChannelList();
  }

  List<Map<String, dynamic>> get list => _list;
}
