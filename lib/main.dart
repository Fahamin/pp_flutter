import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3u/m3u.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:parser_flutter/customList/CustomListItem.dart';
import 'package:parser_flutter/helper/SQLHelper.dart';
import 'package:parser_flutter/model/channelmodel.dart';
import 'package:parser_flutter/playlist.dart';
import 'package:parser_flutter/PlayerScreen/secondPlaer.dart';

import 'bottom_nav_bar.dart';
import 'getFileFromStorage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return GetMaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'IPTV',
            theme: ThemeData(primarySwatch: Colors.amber),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            home: HomePage(),
          );
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChannelModel> list = [];
  List<Map<String, dynamic>> _channelList = [];
  List<Map<String, dynamic>> _foundUsers = [];

  bool _isLoading = true;
  late String codeDialog;
  late String valueText;
  int _selectedIndex = 0;

  TextEditingController _textFieldController = TextEditingController();

  // This function is used to fetch all data from the database
  void _refreshChannelList() async {
    final data = await SQLHelper.getItemByCategory("in");
    setState(() {
      _channelList = data;
      _isLoading = false;
      _foundUsers = _channelList;
    });
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _channelList;
    } else {
      results = _channelList
          .where((user) => user["title"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFile();
    //   _refreshChannelList();
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        _pickFile();
        print("AddFile");
        break;
      case 1:
        print("Add Url");
        _displayTextInputDialog(context);
        break;
    }
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
        appBar: AppBar(
          title: const Text('Flutter Learning'),
          actions: [
            IconButton(
                icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
                onPressed: () {
                  MyApp.themeNotifier.value =
                      MyApp.themeNotifier.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                }),
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text('Add M3u File')),
                PopupMenuItem<int>(value: 1, child: Text('Add M3u Url')),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomMenu(
          selectedIndex: _selectedIndex,
          onClicked: _onItemTapped,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _foundUsers.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundUsers.length,
                        itemBuilder: (context, index) {
                          return CustomListItem(
                            link: _foundUsers[index]['link'],
                            title: _foundUsers[index]['title'],
                            thumbnail: Container(
                              child: _foundUsers[index]['logo']
                                      .toString()
                                      .isNotEmpty
                                  ? Image.network(_foundUsers[index]['logo'])
                                  : Icon(Icons.tv),
                            ),
                            viewCount: 1222,
                          );
                        },
                      )
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              ),
            ],
          ),
        ));
  }

  Future<void> readFile() async {
    var m3u, data;
    final response = await http.get(Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/api-master-3fb49.appspot.com/o/m3u%20file%2Fin.m3u?alt=media&token=da0531d7-55cb-4ec4-b5fd-5b2cad255030"));

    List<Map<String, dynamic>> _foundUsers = [];

    data = await SQLHelper.checkPlayList("come");
    _foundUsers = data;
    print("nothing");

    if (_foundUsers.isEmpty) {
      m3u = await M3uParser.parse(response.body);
      for (final entry in m3u) {
        //add data on db
        _addItem(entry.title, entry.link, entry.attributes["tvg-logo"], "in");
        // add data on listview
        list.add(new ChannelModel(
            entry.title, entry.attributes!["tvg-logo"], entry.link));
      }
      print("Fffffffff");
      await SQLHelper.createPlayList("come");
      print("" + m3u.length.toString());
    } else {
      _refreshChannelList();
      print("data already added");
    }
    //show on console data
    for (int i = 0; i < list.length; i++) {
      // print(list[i].logo);
    }
  }

// Insert a new journal to the database
  Future<void> _addItem(
      String _title, String _link, String? _logo, String cat) async {
    await SQLHelper.createItem(_title, _link, _logo, cat);
    _refreshChannelList();
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['m3u']);
    if (result == null) return;
    print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);
    // we get the file from result object
    final file = result.files.first;
    final source = await File(file.path!).readAsString();
    final m3u = await M3uParser.parse(source);
    for (final entry in m3u) {
      //add data on db
      _addItem(
          entry.title, entry.link, entry.attributes["tvg-logo"], file.name);
      // add data on listview
      list.add(new ChannelModel(
          entry.title, entry.attributes!["tvg-logo"], entry.link));
    }
    print("Fffffffff");
    await SQLHelper.createPlayList(file.name);
    print("" + m3u.length.toString());
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Get.back();
                  });
                },
              ),
            ],
          );
        });
  }
}
