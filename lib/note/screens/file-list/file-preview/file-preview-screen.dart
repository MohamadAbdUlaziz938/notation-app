import 'package:flutter/material.dart';
import 'package:note/note/screens/file-list/file-preview/file-preview-note.dart';
import 'package:note/note/state/file-entry.dart';
import 'package:note/note/state/note-state.dart';
import 'package:note/note/state/root-navigator-key.dart';
import 'package:note/utils/text.dart';
import 'package:provider/provider.dart';

class FilePreviewPageArgs {
  FilePreviewPageArgs(this.fileEntry);
  final FileEntry fileEntry;
}

class FilePreviewScreen extends StatelessWidget {
  static const ROUTE = 'filePreview';
  static open(FileEntry entry) {
    rootNavigatorKey.currentState.pushNamed(FilePreviewScreen.ROUTE,
        arguments: FilePreviewPageArgs(entry));
  }

  @override
  Widget build(BuildContext context) {
    final fileEntry = _setFileEntry(context);
    final name = context.select((NoteState state) {
      return state.entriesFile[fileEntry.documentId].name;
    });

    return fileEntry.type == "note"
        ? NoteFilePreview(fileEntry: fileEntry,)
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: text(name, translate: false),
              actions: [
                //OpenInExternalAppButton(fileEntry),
                //MoreOptionsButton(fileEntry),
              ],
            ),
            body: Container(
              color: Colors.black,
              child: _getFilePreviewWidget(fileEntry),
            ));
  }

  Widget _getFilePreviewWidget(FileEntry fileEntry) {
    if (fileEntry.type == 'video' || fileEntry.type == 'audio') {
      //return VideoFilePreview(fileEntry);
    } else if (fileEntry.type == 'image') {
      //return ImageFilePreview(fileEntry);
    } else if (fileEntry.type == 'note') {
      return NoteFilePreview(fileEntry: fileEntry);
    } else if (fileEntry.type == 'pdf') {
      //return PdfFilePreview(fileEntry);
    } else if (['spreadsheet', 'powerPoint', 'word'].contains(fileEntry.type)) {
      //return OfficeFilePreview(fileEntry);
    } else if (fileEntry.type == 'text') {
      //return TextFilePreview(fileEntry);
    } else {
      //return GenericFilePreview(fileEntry);
    }
  }

  FileEntry _setFileEntry(BuildContext context) {
    final fileEntry =
        (ModalRoute.of(context).settings.arguments as FilePreviewPageArgs)
            .fileEntry;
    //  context.watch<FilePreviewState>().fileEntry = fileEntry;
    return fileEntry;
  }
}

// class MoreOptionsButton extends StatelessWidget {
//   const MoreOptionsButton(this.fileEntry, {Key key}) : super(key: key);
//   final FileEntry fileEntry;
//
//   @override
//   Widget build(BuildContext context) {
//     context.read<DriveState>().set(true);
//     return IconButton(icon: Icon(Icons.more_vert_outlined), onPressed: () async  {
//       final DriveContextAction clickedAction = await showDriveContextActions(
//         [fileEntry],
//         context: context,
//         hidePreview: true,
//       );
//
//
//       // if (clickedAction != null) {
//       //   Navigator.of(context).pop();
//       // }
//     });
//   }
// }
