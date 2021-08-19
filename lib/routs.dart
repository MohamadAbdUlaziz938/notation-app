
import 'package:flutter/material.dart';
import 'package:note/auth/screen/signin.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:note/note/screens/addnotes.dart';
import 'package:note/note/screens/editnotes.dart';
import 'package:note/note/screens/homepage.dart';
import 'package:note/note/screens/viewnotes.dart';
import 'package:provider/provider.dart';

import 'auth/screen/register.dart';
MaterialPageRoute buildRoute(RouteSettings settings) {
  switch (settings.name) {

    case ViewNote.ROUTE:
      ViewNoteArgs args = settings.arguments;
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(ViewNote(notes: args.notes,)), settings: settings);
    case AddNotes.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(AddNotes()), settings: settings);
    case EditNotes.ROUTE:
      EditNotesArgs args = settings.arguments;
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(EditNotes(docid:args.docid,list:args.list)), settings: settings);
    case EditNotes.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(EditNotes()), settings: settings);
    case Login.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(Login()), settings: settings);
    case SignUp.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(SignUp()), settings: settings);
    case HomePage.ROUTE:
      return MaterialPageRoute(builder: (_) => loadingWillPopScope(HomePage()), settings: settings);



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