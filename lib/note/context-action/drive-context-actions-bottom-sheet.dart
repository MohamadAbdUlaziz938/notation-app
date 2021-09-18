import 'package:flutter/material.dart';
import 'package:note/note/state/file-entry.dart';
import 'package:note/note/state/note-state.dart';
import 'package:note/utils/text.dart';
import 'package:provider/provider.dart';

import 'context-menu-sizes.dart';

class DriveContextActionsBottomSheet extends StatelessWidget {
  DriveContextActionsBottomSheet(
    this.entries,
    this.tiles,
    this.driveState, {
    Key key,
  }) : super(key: key);
  final List<FileEntry> entries;
  final List<ListTile> tiles;
  final NoteState driveState;
  bool deleteWhenFileOpened;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteState>.value(
      value: driveState,
      child: Container(
          height: (tiles.length * CONTEXT_MENU_ITEM_HEIGHT +
                  CONTEXT_MENU_HEADER_HEIGHT)
              .toDouble(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Theme.of(context).dividerColor)),
                ),
                child: _Header(entries),
              ),
              Expanded(
                  child: ListView(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: tiles))
            ],
          )),
    );
  }
}

class _Header extends StatelessWidget {
  _Header(this.entries, {Key key}) : super(key: key);
  final List<FileEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.length == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //FileThumbnail(entries[0], size: FileThumbnailSize.small),
          SizedBox(width: 10),
          Expanded(
            child: text(entries[0].name, translate: false),
          )
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 8),
        child: text(':count Items',
            replacements: {'count': entries.length.toString()}),
      );
    }
  }
}
