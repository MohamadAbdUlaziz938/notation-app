import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/utils/text.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class MainAppBar extends StatelessWidget {
  MainAppBar({Key key, this.mainAppBar}) : super(key: key);
  bool mainAppBar = true;

  @override
  Widget build(BuildContext context) {
    // final name = context.select((DriveState s) => s.activePage.name);
    // final isFolderPage = context.select((DriveState s) => s.activePage.folder != null);
    return mainAppBar
        ? AppBar(
            elevation: 0,
            shape: RoundedRectangleBorder(),
            titleSpacing: 20,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            title: text(
              "Notation",
              color: Colors.white,
            ),
            // bottom: TabBar(
            //     indicatorColor: Color(0xFF21BFBD),
            //
            //     //enableFeedback: true,
            //     labelColor: Colors.white,
            //     automaticIndicatorColorAdjustment: true,
            //     tabs: [
            //       Tab(
            //         icon: Icon(
            //           Icons.camera_alt,
            //           color: Colors.white,
            //         ),
            //       ), //text: "media",
            //
            //       Tab(
            //         text: "Home",
            //       ),
            //       Tab(
            //         text: "Chat",
            //       ),
            //       Tab(
            //         text: "media",
            //       )
            //     ]),
            actions: [
              _notificationButton(context),
              _searchButton(context),
            ],
          )
        : AppBar(
            elevation: 0,
            title: text("main", color: Colors.transparent),
          );
  }
}

// _uploadButton(BuildContext context) {
//   return IconButton(icon: Icon(Icons.add_outlined), onPressed: () {
//
//     showModalBottomSheet(
//
//         enableDrag: true,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))),
//         context: context,
//         builder: (BuildContext _) => AddNewItemBottomSheet(context.read<DriveState>())
//     );
//   });
// }
_notificationButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.notification_important_outlined),
      color: Colors.white,
      onPressed: () {
//    Navigator.of(context).pushNamed(SearchScreen.ROUTE);
      });
}

_searchButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.search_outlined),
      color: Colors.white,
      onPressed: () {
//    Navigator.of(context).pushNamed(SearchScreen.ROUTE);
      });
}
