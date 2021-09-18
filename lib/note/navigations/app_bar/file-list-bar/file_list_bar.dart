import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileListBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final shouldHide = context.select((DriveState s) => s.activePage is SearchPage);
    // if (shouldHide) {
    //   return SliverToBoxAdapter(child: Container());
    // }
    return SliverAppBar(
      primary: false,
      automaticallyImplyLeading: true,
      floating: false,
      elevation: 0,
      toolbarHeight: 35,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      brightness: Theme.of(context).brightness,
      title:Text("w") ,
      centerTitle: false,
      titleSpacing: 4,
      bottom: PreferredSize(
          child: Container(
            color: Theme.of(context).dividerColor,
            height: 1,
          ),
          preferredSize: Size.fromHeight(1)
      ),
      actions: [
        //FileViewModeButton(),
      ],
    );
  }
}



