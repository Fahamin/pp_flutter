import 'package:flutter/material.dart';

import 'customList/CustomListItem.dart';

class SingleList extends StatelessWidget {
  var singleList;

  SingleList(this.singleList, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Expanded(
          child: singleList.isNotEmpty
              ? ListView.builder(
                  itemCount: singleList.length,
                  itemBuilder: (context, index) {
                    return CustomListItem(
                      link: singleList[index]['link'],
                      title: singleList[index]['title'],
                      thumbnail: Container(
                        child: singleList[index]['logo'].toString().isNotEmpty
                            ? Image.network(singleList[index]['logo'])
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
      ),
    ));
  }
}
