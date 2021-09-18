
import 'package:flutter/material.dart';
import 'package:note/auth/screen/signin.dart';
import 'package:note/messaging.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:note/note/screens/addnotes.dart';
import 'package:note/note/screens/file-list/base_file_list_screen.dart';
import 'package:note/note/screens/editnotes.dart';
import 'package:note/note/screens/file-list/file-preview/file-preview-screen.dart';
import 'package:note/note/screens/file-list/root_screen.dart';
import 'package:note/note/screens/file-list/file-preview/file-preview-note.dart';
import 'package:note/transfers/transfer-screen/transfer-screen.dart';
import 'package:provider/provider.dart';

import 'auth/screen/register.dart';
import 'donwload_button_test.dart';
MaterialPageRoute buildRoute(RouteSettings settings) {
  print(settings.name);
  switch (settings.name) {
    case FilePreviewScreen.ROUTE:
      //ViewNoteArgs args = settings.arguments;
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(FilePreviewScreen()), settings: settings);
    case AddNotes.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(AddNotes()), settings: settings);
    case EditNotes.ROUTE:
      EditNotesArgs args = settings.arguments;
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(EditNotes(note:args.note)), settings: settings);
    case Login.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(Login()), settings: settings);
    case SignUp.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(SignUp()), settings: settings);
    case RootScreen.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(RootScreen()), settings: settings);
    case messaging.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(messaging()), settings: settings);
    case DownLoadButton2.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(DownLoadButton2()), settings: settings);
    case TransfersScreen.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(TransfersScreen()), settings: settings);
    // case BaseFileListSceen.ROUTE:
    //   return MaterialPageRoute(builder: (_) => loadingWillPopScope(BaseFileListSceen()), settings: settings);


  //   case FolderScreen.ROUTE:
  //     FolderScreenArgs args = settings.arguments;
  //     // don't maintain drive.state so back button loads file entries properly
  //     return NoTransitionMaterialRoute(builder: (_) => loadingWillPopScope(FolderScreen(args.folderPage)), settings: settings, maintainState: false);
  //
  // // SHARE
  //   case ManageUsersScreen.ROUTE:
  //     ManageUsersArgs args = settings.arguments;
  //     return MaterialPageRoute(builder: (_) => loadingWillPopScope(ChangeNotifierProvider(
  //       create: (bc) => ManageEntryUsersState(bc.read<DriveState>()),
  //       child: ManageUsersScreen(args.fileEntry),
  //     )), settings: settings);
  //   case ShareableLinkScreen.ROUTE:
  //     ShareableLinkArgs args = settings.arguments;
  //     return MaterialPageRoute(builder: (_) => loadingWillPopScope(ChangeNotifierProvider(
  //       create: (bc) => ShareableLinkState(bc.read<DriveState>(), args.fileEntry),
  //       child: ShareableLinkScreen(),
  //     )), settings: settings);


  }
}

class NoTransitionMaterialRoute extends MaterialPageRoute {
  NoTransitionMaterialRoute({
    @required builder,
    RouteSettings settings,
    maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
      builder: builder,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog

  );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 10);
}