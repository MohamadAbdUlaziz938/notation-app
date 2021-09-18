

import 'package:flutter/material.dart';
import 'package:note/note/state/file-entry.dart';
import 'package:note/note/state/note-state.dart';
import 'package:provider/provider.dart';

class NoteFilePreview extends StatelessWidget {
  const NoteFilePreview({Key key, this.fileEntry}) : super(key: key);
  final FileEntry fileEntry;
  @override
  Widget build(BuildContext context) {
    print("");
    final name = context.select((NoteState noteState) =>
        noteState.entriesFile[fileEntry.documentId].name);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [SaveChange()],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
                child: Image.network(
              "${fileEntry.url}",
              width: double.infinity,
              height: 300,
              fit: BoxFit.fill,
            )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "${fileEntry.name}",
                  style: Theme.of(context).textTheme.headline5,
                )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "${fileEntry.description}",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}

class SaveChange extends StatelessWidget {
  const SaveChange({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.done));
  }
}
