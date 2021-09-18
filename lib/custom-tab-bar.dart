import 'package:flutter/material.dart';
import 'package:note/note/screens/file-list/base_file_list_screen.dart';
import 'package:note/note/state/note-state.dart';
import 'package:provider/provider.dart';
class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key key}) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    final _currentIndex=context.select((NoteState noteState) => noteState.currentIndex);
    final _pageController=context.read<NoteState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TabBar(
          tabText: "Note",
          selectedPage: _currentIndex,
          pageNumber: 0,
          function: () {
            _pageController.CurrentIndexPageController(0);
          },
        ),
        TabBar(
          tabText: "Media",
          selectedPage: _currentIndex,
          pageNumber: 1,
          function: () {
            _pageController.CurrentIndexPageController(1);
          },
        ),
        TabBar(
          tabText: "Chat",
          selectedPage: _currentIndex,
          pageNumber: 2,
          function: () {
            _pageController.CurrentIndexPageController(2);
          },
        ),
      ],
    );
  }
}

class TabBar extends StatelessWidget {
  const TabBar(
      {Key key,
      this.tabText,
      this.selectedPage,
      this.pageNumber,
      this.function})
      : super(key: key);
  final String tabText;
  final int selectedPage;
  final int pageNumber;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: AnimatedContainer(
        width: 70,
        height:35,
        duration: Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: selectedPage == pageNumber ? Colors.white54 : Color(0xFF21BFBD),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: selectedPage == pageNumber ? 4 : 0,
            vertical: selectedPage == pageNumber ? 4: 0),
        margin: EdgeInsets.symmetric(
            horizontal: selectedPage == pageNumber ? 0 : 10,
        //    vertical: selectedPage == pageNumber ? 0 : 8
        ),
        child: Center(
          child: Text(
            tabText ?? "",
            style: TextStyle(
                color: selectedPage == pageNumber ? Colors.white : Colors.white),
          ),
        ),
      ),
    );
  }
}
