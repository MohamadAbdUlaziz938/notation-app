import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note/config/app-config.dart';
import 'package:note/note/dialogs/message-dialog.dart';
import 'package:note/note/dialogs/show_snack_bar.dart';
import 'package:note/note/state/file-entry.dart';
import 'package:note/note/state/note-state.dart';
import 'package:note/note/state/note.dart';
import 'package:note/note/state/root-navigator-key.dart';
import 'package:note/transfers/transfer-queue/transfer-queue.dart';
import 'package:note/transfers/transfer-screen/transfer-screen.dart';
import 'package:note/utils/text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

enum DriveContextAction {
  preview,
  manageUsers,
  shareableLink,
  //toggleStarred,
  rename,
  move,
  delete,
  restore,
  deleteForever,
  unshare,
  copyToOwnDrive,
  download,
  toggleOfflined,
}

extension GetContextAction on DriveContextAction {
  // ignore: missing_return
  DriveContextActionConfig getConfig(BuildContext context, List<FileEntry> entries) {
    switch (this) {
      case DriveContextAction.preview:
        return _Preview(context, entries,Icon(Icons.remove_red_eye_outlined,));
      case DriveContextAction.manageUsers:
        return _ManageUsers(context, entries,Icon(Icons.group_add_outlined,),);
      case DriveContextAction.shareableLink:
        return _ShareableLink(context, entries,Icon(Icons.link_outlined,));
      // case DriveContextAction.toggleStarred:
      //   return _ToggleStarred(context, entries,Icon(Icons.star_outline,));
      case DriveContextAction.rename:
        return _Rename(context, entries,Icon(Icons.edit_outlined,));
      case DriveContextAction.move:
        return _Move(context, entries,Icon(Icons.drive_file_move_outline,));
      case DriveContextAction.copyToOwnDrive:
        return _CopyToOwnDrive(context, entries,Icon(Icons.copy_outlined,));
      case DriveContextAction.delete:
        return _Delete(context, entries,Icon(Icons.delete_outline_outlined,),);
      case DriveContextAction.restore:
        return _Restore(context, entries,Icon(Icons.restore_outlined,));
      case DriveContextAction.deleteForever:
        return _DeleteForever(context, entries,Icon(Icons.delete_forever_outlined,));
      case DriveContextAction.unshare:
        return _Unshare(context, entries,Icon(Icons.delete_outline_outlined,));
      case DriveContextAction.download:
        return _Download(context, entries,Icon(Icons.download_outlined,));
      case DriveContextAction.toggleOfflined:
        return _ToggleOfflined(context, entries,Icon(Icons.offline_pin_rounded,));
    }
  }
}

abstract class DriveContextActionConfig {
  DriveContextActionConfig({
    @required this.name,
    @required this.entries,
    @required this.context,
    this.icon,
    this.displayName,
    //this.permission,
    this.supportsMultipleEntries = false,

  });
  Icon icon;
  String displayName;
  DriveContextAction name;
  final List<FileEntry> entries;
  final BuildContext context;
  //EntryPermission permission;
  bool supportsMultipleEntries;

  void onTap();

  NoteState get driveState => rootNavigatorKey.currentContext.read<NoteState>();
}

class _Download extends DriveContextActionConfig {
  _Download(BuildContext context, List<FileEntry> entries,Icon icon)
      : super(
    supportsMultipleEntries: true,
    //permission: EntryPermission.download,
    //icon: const Icon(Icons.download_outlined),
    icon: icon,
    name: DriveContextAction.download,
    displayName: 'Download',
    context: context,
    entries: entries,
  );

  onTap() async {
    final transfers = context.read<TransferQueue>();
    final appName = context.read<AppConfig>().appName;
    String destination;
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        destination = '/storage/emulated/0/Download';
      } else {
        showMessageDialog(context, ('$appName needs storage permissions in order to download files. You can grant this permission from app settings.'));
      }
    } else {
      destination = (await getApplicationDocumentsDirectory()).path;
    }
    if (destination != null) {
      entries.forEach((entry) {
        transfers.addDownload(entry, '$destination/${entry.name}');
      });
      //driveState.deselectAll();
      showSnackBar(
        replacePlaceHolders('Queued :count items for download.',  {'count': entries.length.toString()}),
        context,
        action: SnackBarAction(label: ('View'), onPressed: () {
          rootNavigatorKey.currentState.pushNamed(TransfersScreen.ROUTE);
        }),

      );
    }
  }
}

class _Preview extends DriveContextActionConfig {
  _Preview(BuildContext context, List<FileEntry> entries,Icon icon)
      : super(
    //icon: const Icon(Icons.remove_red_eye_outlined),
    icon: icon,
    name: DriveContextAction.preview,
    displayName: 'Preview',
    context: context,
    entries: entries,
  );

  onTap() {
    //FilePreviewScreen.open(entries[0]);
  }
}

class _ManageUsers extends DriveContextActionConfig {
  _ManageUsers(BuildContext context, List<FileEntry> entries,Icon icon) : super(
    context: context,
    entries: entries,
    //icon: const Icon(Icons.group_add_outlined,color: Color(0xFF026072),),
    icon: icon,
    name: DriveContextAction.manageUsers,
    displayName: 'Manage Collaborators',
    //permission: EntryPermission.update,
  );

  onTap() {
   // Navigator.of(context).pushNamed(ManageUsersScreen.ROUTE, arguments: ManageUsersArgs(entries.first));
  }
}

class _ShareableLink extends DriveContextActionConfig {
  _ShareableLink(BuildContext context, List<FileEntry> entries,Icon icon) : super(
    context: context,
    entries: entries,
    //icon: const Icon(Icons.link_outlined,color: Color(0xFF026072),),
    icon: icon,
    name: DriveContextAction.shareableLink,
    displayName: 'Get Shareable Link',
    //permission: EntryPermission.update,
  );

  onTap() {
    //Navigator.of(context).pushNamed(ShareableLinkScreen.ROUTE, arguments: ShareableLinkArgs(entries.first));
  }
}

/*class _ToggleStarred extends DriveContextActionConfig {
  _ToggleStarred(BuildContext context, List<FileEntry> entries,Icon icon) : super(
    context: context,
    entries: entries,
    supportsMultipleEntries: true,
    name: DriveContextAction.toggleStarred,
  ) {
    final allStarred = entries.every((e) => e.isStarred());
    this.displayName = allStarred ? 'Remove from Starred' : 'Add to Starred';
    this.icon = allStarred ? Icon(Icons.star_outline, color: Colors.orange) :icon;
  }

  onTap() async {
    if (entries[0].isStarred()) {
      try {
        await context.read<DriveState>().removeFromStarred(entries.map((e) => e.id).toList());
        showSnackBar(trans('Removed from starred'), context);
      } on BackendError catch(e) {
        showSnackBar(trans(e.message), context);
      }
    } else {
      try {
        await context.read<DriveState>().addToStarred(entries.map((e) => e.id).toList());
        showSnackBar(trans('Added to starred'), context);
      } on BackendError catch(e) {
        showSnackBar(trans(e.message), context);
      }
    }
  }
}*/

class _Rename extends DriveContextActionConfig {
  _Rename(BuildContext context, List<FileEntry> entries,Icon icon)
      : super(
    context: context,
    entries: entries,
    //icon: Icon(Icons.edit_outlined,color: Color(0xFF026072),),
    icon: icon,
    name: DriveContextAction.rename,
    displayName: 'Rename',
  );

  onTap() async{
    //await showCrupdateEntryDialog(context, fileEntry: entries[0]);
  }
}

class _Move extends DriveContextActionConfig {
  _Move(BuildContext context, List<FileEntry> entries,Icon icon_,
      {this.disableMoveAction = false,
        DriveContextAction name,
        String displayName,
        Icon icon,
        EntryPermission permission})
      : super(
    context: context,
    entries: entries,
    supportsMultipleEntries: true,
    //icon: icon ?? const Icon(Icons.drive_file_move_outline,color: Color(0xFF026072),),
    icon: icon ?? icon_,
    name: name ?? DriveContextAction.move,
    displayName: displayName ?? 'Move / Copy',
    //permission: permission ?? EntryPermission.update,
  );
  final bool disableMoveAction;

  onTap() {
    //context.read<DestinationPickerState>().open(disableMoveAction: disableMoveAction, entries: entries);
  }
}

class _CopyToOwnDrive extends _Move {
  _CopyToOwnDrive(
      BuildContext context,
      List<FileEntry> entries,
      Icon icon_
      ) : super(
    context,
    entries,
    icon_,
    disableMoveAction: true,
    name: DriveContextAction.copyToOwnDrive,
    displayName: 'Make a Copy',
    //icon: const Icon(Icons.copy_outlined,color: Color(0xFF026072),),
    icon: icon_,
    permission: EntryPermission.download,
  );
}

class _Delete extends DriveContextActionConfig {

  _Delete(BuildContext context, List<FileEntry> entries,Icon icon,{bool  deleteWhenFileOpened})
      : super(

    context: context,
    entries: entries,
    supportsMultipleEntries: true,
    //icon: Icon(Icons.delete_outline_outlined,color: Color(0xFF026072),),
    icon: icon,
    name: DriveContextAction.delete,
    displayName: 'Delete',
    //permission: EntryPermission.delete,


  );

  onTap() async {

    try {
      await context.read<NoteState>().deleteEntries(entries.map((e) => e.documentId).toList());
      //context.read<NoteState>().deselectAll();
      bool deleteWhenFileOpened=context.read<NoteState>().deleteWhenFileOpened;
      if(deleteWhenFileOpened){
        Navigator.of(context).pop();
      }
    }  catch(e) {
      showSnackBar(e.message, context);
    }

  }
}

class _Unshare extends DriveContextActionConfig {
  _Unshare(BuildContext context, List<FileEntry> entries,Icon icon)
      : super(
    context: context,
    entries: entries,
    supportsMultipleEntries: true,
    //icon: Icon(Icons.delete_outline_outlined,color: Color(0xFF026072),),
    icon:icon,
    name: DriveContextAction.delete,
    displayName: 'Remove',
    //permission: EntryPermission.delete,
  );

  onTap() async {
    // try {
    //   final state = context.read<DriveState>();
    //   await state.unshare(entries.map((e) => e.id).toList(), context.read<AuthState>().currentUser.id);
    //   //showSnackBar(trans('Removed :count items.', replacements: {'count': entries.length.toString()}), context);
    // } catch (e) {
    //   showSnackBar(trans(e.message), context);
    // }
  }
}

class _Restore extends DriveContextActionConfig {
  _Restore(BuildContext context, List<FileEntry> entries,Icon icon)
      : super(
    context: context,
    entries: entries,
    supportsMultipleEntries: true,
    //icon: Icon(Icons.restore_outlined,color: Color(0xFF026072),),
    icon: icon,
    name: DriveContextAction.restore,
    displayName: 'Restore',
    //permission: EntryPermission.update,
  );

  onTap() async {
    // try {
    //   await context.read<DriveState>().restoreEntries(entries.map((e) => e.id).toList());
    //   context.read<DriveState>().deselectAll();
    // } on BackendError catch (e) {
    //   showSnackBar(trans(e.message), context);
    // }
  }
}

class _DeleteForever extends DriveContextActionConfig {
  _DeleteForever(BuildContext context, List<FileEntry> entries,Icon icon)
      : super(
    context: context,
    entries: entries,
    supportsMultipleEntries: true,
    //icon: Icon(Icons.delete_forever_outlined,color: Color(0xFF026072),),
    icon: icon,
    name: DriveContextAction.deleteForever,
    displayName: 'Delete Forever',
    //permission: EntryPermission.delete,
  );

  onTap() async {
    //try {
    //   await context.read<DriveState>().deleteEntries(entries.map((e) => e.id).toList(), deleteForever: true);
    //   context.read<DriveState>().deselectAll();
    //   bool deleteWhenFileOpened=context.read<DriveState>().GetdeleteWhenFileOpened;
    //   if(deleteWhenFileOpened){
    //     Navigator.of(context).pop();
    //   }
    // } on BackendError catch(e) {
    //   showSnackBar(trans(e.message), context);
    // }

  }
}

class _ToggleOfflined extends DriveContextActionConfig {
  _ToggleOfflined(BuildContext context, List<FileEntry> entries,Icon icon) : super(
    context: context,
    entries: entries,
    supportsMultipleEntries: true,
    name: DriveContextAction.toggleOfflined,
    //permission: EntryPermission.download,
  ) {
    // final allOfflined = entries.every((e) => context.read<OfflinedEntries>().offlinedEntryIds.contains(e.id));
    // this.displayName = allOfflined ? 'Available offline' : 'Make available offline';
    // this.icon = allOfflined ? Icon(Icons.offline_pin_rounded, color: Colors.green) : icon;
  }

  onTap() {
    // final offlinedEntries = context.read<OfflinedEntries>();
    // if (entries.every((e) => offlinedEntries.offlinedEntryIds.contains(e.id))) {
    //   offlinedEntries.unoffline(entries);
    //   if (driveState.activePage is OfflinedPage) {
    //     driveState.removeEntries(entries.map((e) => e.id).toList(), notify: true);
    //   }
    //   showSnackBar(trans('Files will no longer be available offline'), context);
    // } else {
    //   if (offlinedEntries.offline(entries, context: context) != null) {
    //     showSnackBar(trans('Making files available offline'), context);
    //   }
    // }
  }
}
