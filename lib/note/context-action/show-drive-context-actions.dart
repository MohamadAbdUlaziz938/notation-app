
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note/note/state/file-entry.dart';
import 'package:note/note/state/note-state.dart';
import 'package:note/utils/text.dart';
import 'package:provider/provider.dart';

import 'drive-context-actions-bottom-sheet.dart';
import 'drive-context-actions.dart';

Future<DriveContextAction> showDriveContextActions(
  List<FileEntry> entries, {
  @required BuildContext context,
  bool hidePreview = false,
}) {
  final state = context.read<NoteState>();
  final onlyIncludesFolders = entries.every((e) => e.type == 'folder');
  List<DriveContextActionConfig> actions = state.activePage.contextActions
      .map((a) => a.getConfig(context, entries))
      .toList();

  // actions = actions
  //   ..retainWhere((a) {
  //     final showPreview = (a.name != DriveContextAction.preview) ||
  //         (!hidePreview && !onlyIncludesFolders);
  //     final hideOnIos = a.name == DriveContextAction.download && Platform.isIOS;
  //     final hasPermissions = a.permission == null ||
  //         entries.every((e) => e.permissions.contains(a.permission));
  //     final showForMultiple = a.supportsMultipleEntries || entries.length == 1;
  //     return !hideOnIos && showPreview && hasPermissions && showForMultiple;
  //   });
  actions = actions
    ..retainWhere((a) {
      final showPreview = (a.name != DriveContextAction.preview) ||
          (!hidePreview && !onlyIncludesFolders);
      final hideOnIos = a.name == DriveContextAction.download && Platform.isIOS;
      // final hasPermissions = a.permission == null ||
      //     entries.every((e) => e.permissions.contains(a.permission));
      final showForMultiple = a.supportsMultipleEntries || entries.length == 1;
      return !hideOnIos && showPreview  && showForMultiple;
    });

  final List<ListTile> tiles = actions.map((a) {
    return ListTile(
      leading: a.icon,
      title: text(a.displayName),
      onTap: () {
        Navigator.of(context).pop(a.name);
        a.onTap();
      },
    );
  }).toList();

  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (BuildContext _) {
        return DriveContextActionsBottomSheet(entries, tiles, state);
      });
}
