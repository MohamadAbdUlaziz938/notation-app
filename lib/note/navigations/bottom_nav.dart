import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:note/note/screens/file-list/base_file_list_screen.dart';
import 'package:note/note/screens/file-list/root_screen.dart';
import 'package:note/utils/text.dart';

class BottomNav extends StatelessWidget {
   BottomNav({Key key,this.pageController}) : super(key: key);
int currentIndex=0;
  PageController pageController;
   void selectIndex(int index) {
     if (index == currentIndex) {
       return;
     }
     pageController.animateToPage(
       index,
       duration: kThemeAnimationDuration,
       curve: Curves.easeInOut,
     );
   }
  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.name;
    if (name != null && _BottomNavIndex[name] != null) {
      currentIndex = _BottomNavIndex[name];
    }

    return FFNavigationBar(
      theme: FFNavigationBarTheme(
        barBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemBorderColor: Colors.transparent,
        selectedItemBackgroundColor: Theme.of(context).appBarTheme.color,
        selectedItemIconColor: Colors.white,
        showSelectedItemShadow: true,
        selectedItemLabelColor: Theme.of(context).textTheme.bodyText1.color,
        //barHeight: 60,
      ),
      selectedIndex: currentIndex,
      onSelectTab:selectIndex,
      //     (index) {
      //   currentIndex = index;
      //   final routeName =
      //   _BottomNavIndex.keys.firstWhere((k) => _BottomNavIndex[k] == index);
      //   if (_BottomNavIndex.keys
      //       .contains(ModalRoute.of(context).settings.name)) {
      //     Navigator.of(context).pushReplacementNamed(routeName);
      //   } else {
      //     Navigator.of(context).pushNamed(routeName);
      //   }
      // },
      items: [
        FFNavigationBarItem(
          iconData: Icons.folder_open_outlined,
          label: 'Files',
        ),
        FFNavigationBarItem(
          iconData: Icons.access_time_outlined,
          label: "Recent",
        ),
        FFNavigationBarItem(
          iconData: Icons.people_outline,
          label: "Shared",
        ),
        FFNavigationBarItem(
          iconData: Icons.star_outline,
          label: "Starred",
        ),
      ],
    );


  }
}


const _BottomNavIndex = {
  RootScreen.ROUTE: 0,
  // RecentScreen.ROUTE: 1,
  // SharedScreen.ROUTE: 2,
  // StarredScreen.ROUTE: 3,
};
