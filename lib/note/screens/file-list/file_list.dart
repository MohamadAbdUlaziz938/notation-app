import 'dart:ui';
import 'package:auto_animated/auto_animated.dart';
import 'package:charcode/html_entity.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/note/context-action/show-drive-context-actions.dart';
import 'package:note/note/screens/file-list/file-preview/file-preview-screen.dart';
import 'package:note/note/state/entry_cach.dart';
import 'package:note/note/state/file-entry.dart';
import 'package:note/note/state/note-state.dart';
import 'package:provider/provider.dart';


class FileList extends StatelessWidget {
  FileList(this.entries, {Key key}) : super(key: key);
  final List<String> entries;
  //final bool isRefreshIndecator;
  GlobalKey<SliverAnimatedListState> listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final state = context.select((NoteState s) =>s.entriesFile );
    final noteState=Provider.of<NoteState>(context,listen: true);
    print("rebuild");
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {

          final state2 = context.read<EntryCache>();
          final fileEntry = noteState.entriesFile[entries[index]];
          //final fileEntry = state.entriesFile[entries[index]];
          return FileListItem(fileEntry: fileEntry);
        },
        childCount: entries.length,
      ),
    );
  }
}

class FileListItem extends StatelessWidget {
  final FileEntry fileEntry;
  // final docid;
  FileListItem({this.fileEntry});

  @override
  Widget build(BuildContext context) {
    Widget build(BuildContext context, Widget widget) {
      return Center();
    }

    return Padding(
      padding: EdgeInsets.only(left: 30, right: 20),
      child: InkWell(
        onTap: () {
          FilePreviewScreen.open(fileEntry);
          // Navigator.of(context)
          //     .pushNamed("viewNote", arguments: ViewNoteArgs(note));
        },
        child: Card(
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Image.network("${fileEntry.url}",
                      fit: BoxFit.fill,
                      height: 80,
                      loadingBuilder: (BuildContext context,
                          Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                        child: CircularProgressIndicator(
                      // value: loadingProgress.expectedTotalBytes != null
                      //     ? loadingProgress.cumulativeBytesLoaded /
                      //         loadingProgress.expectedTotalBytes
                      //     : null,
                    ));
                  }
                  )),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text("${fileEntry.name}"),
                  subtitle: Text(
                    "${fileEntry.description}",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      FileEntry file = FileEntry(
                        fileName: "d",
                        documentId: "d",
                        fileSize: 20,
                        name: "d",
                        downloadFingerprint: "dsa",
                        url: "http",
                      );
                      // Navigator.of(context).pushNamed("editNote",arguments: EditNotesArgs(note));
                      showDriveContextActions([file], context: context);
                    },
                    icon: Icon(Icons.more_vert_outlined),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
