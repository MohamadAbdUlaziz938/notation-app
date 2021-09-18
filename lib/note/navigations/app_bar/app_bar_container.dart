import 'package:flutter/material.dart';
import 'package:note/note/navigations/app_bar/main_app_bar.dart';
import 'package:provider/provider.dart';

class AppBarContainer extends StatelessWidget with PreferredSizeWidget {
   final double barHeight = 50;
   String title;

   bool mainAppBar=true;
   AppBarContainer({
     this.mainAppBar,
   });
  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight+20);


  @override
  Widget build(BuildContext context) {
//    final isSelectionMode = context.select((DriveState s) => s.selectedEntries.isNotEmpty);
    //return isSelectionMode ? SelectionModeAppBar() : MainAppBar(themeIconController: themeIconController);
    //
    // return isSelectionMode ?SelectionModeAppBar(
    //   themeIconController: themeIconController,
    //   key:ValueKey(1),
    // ):MainAppBar(themeIconController: themeIconController,mainAppBar: mainAppBar,
    //   key: ValueKey(2),
    // );
    return MainAppBar(mainAppBar: true,);
  }
}
