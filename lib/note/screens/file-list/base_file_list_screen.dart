import 'package:flutter/material.dart';
import 'package:note/custom-tab-bar.dart';
import 'package:note/donwload_button_test.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:note/note/navigations/app_bar/app_bar_container.dart';
import 'package:note/note/screens/file-list/file_list_container.dart';

import 'package:note/note/state/file_pages.dart';
import 'package:note/note/state/note-state.dart';
import 'package:provider/provider.dart';

abstract class BaseFileListScreen extends StatefulWidget {
  final FilePage page = RootFolderPage();
  @override
  _BaseFileListSceen createState() => _BaseFileListSceen();
}

class _BaseFileListSceen extends State<BaseFileListScreen> {
  PageController _pageController;
  TabController _controller;
  Duration pageTurnDuration = Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //_pageController.addListener(pageControllerListener);
    context.read<NoteState>().openPage(widget.page);
  }

  // void pageControllerListener() {
  //   print("add");
  //   final int currentPage = _pageController.page?.round();
  //   if (currentPage != null && currentPage != currentIndex) {
  //     print(currentPage);
  //     print(currentIndex);
  //     currentIndex = currentPage;
  //     _pageController.animateToPage(currentIndex,
  //         duration: pageTurnDuration, curve: pageTurnCurve);
  //
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final pageController =
        context.select((NoteState noteState) => noteState.pageController);
    final noteState=context.read<NoteState>();
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      appBar: AppBarContainer(
        mainAppBar: true,
      ),
      body: Column(
        children: [
          CustomTabBar(),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(65.0)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: PageView(
                    controller: pageController,
                    children: [
                      //  DownLoadButton2(),
                      FileListContainer(),
                      DownLoadButton2(),
                      DownLoadButton2(),
                    ],
                    onPageChanged:(page){ noteState.CurrentIndexPageController(page,onTap: false);},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    double curveHeight = size.height / 2;
    var p = Path();
    p.lineTo(0, height - curveHeight);
    p.quadraticBezierTo(width / 2, height, width, height - curveHeight);
    p.lineTo(width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
