import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int>? onClicked;
  BottomMenu({this.selectedIndex, this.onClicked});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'PlayList',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.new_releases),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_answer),
          label: 'M3U',
        )
      ],
      currentIndex: selectedIndex,
      onTap: onClicked,
      selectedItemColor: Colors.red[800],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
    );
  }
}
