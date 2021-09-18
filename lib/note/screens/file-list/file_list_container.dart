import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:note/note/navigations/app_bar/file-list-bar/file_list_bar.dart';
import 'package:note/note/screens/file-list/file_list.dart';
import 'package:note/note/state/file_pages.dart';
import 'package:note/note/state/note-state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class FileListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<NoteState>(context, listen: false);
    return CustomScrollView(
      primary: false,
      controller: state.scrollController,
      slivers: <Widget>[
        //FileListBar(),
        SliverToBoxAdapter(child: Container()),
        _Body(state: state),
        // SliverToBoxAdapter(
        //   child: _Footer(state: state),
        // ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    @required this.state,
    Key key,
  }) : super(key: key);
  final NoteState state;
  //final bool isRefreshIndecator;

  @override
  Widget build(BuildContext context) {
    //final FileListMode mode = context.select((PreferenceState s) => s.fileListMode);
    //final pagination = context.select((DriveState s) => s.pagination);
    //final isInitialLoad = pagination.currentPage == null;
    final isInitialLoad = true;
    final loadingFromBackend =
        context.select((NoteState s) => s.isLoadingFromBackend);
    //final backendError = context.select((DriveState s) => s.lastBackendError);
    final entries = context.select((NoteState s) => s.entries);
    final state = Provider.of<NoteState>(context, listen: false);
    print(loadingFromBackend);
    if (isInitialLoad && loadingFromBackend) {
      return SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()));
    }
    /*else if (isInitialLoad && backendError != null) {
      return SliverPadding(
        //padding: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        sliver: SliverFillRemaining(
          child: Container(
              padding: EdgeInsets.all(20),
              child: ErrorIndicator(
                  compact: state.pagination.currentPage != null,
                  error: state.lastBackendError,
                  onTryAgain: state.reloadEntries
              )
          ),
        ),
      );
    }*/
    /*else if (pagination.total == 0 && entries.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverFillRemaining(
            child: Center(
              child: NoResultsIndicator(),
            )
        ),
      );
    }*/

    else {
      return SliverPadding(
        // padding: mode == FileListMode.grid ? const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10) : EdgeInsets.only(top: 5,bottom: 10),
        //padding: mode == FileListMode.grid ? const EdgeInsets.all(10) : EdgeInsets.all(0),
        padding: EdgeInsets.only(left: 20),
        //sliver: mode == FileListMode.grid ? FileGrid(entries,isRefreshIndecator:context.select((DriveState s) => s.isRefreshIndecator_get)) : FileList(entries,isRefreshIndecator:context.select((DriveState s) => s.isRefreshIndecator_get))
        sliver: FileList(entries),
      );
    }
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    @required this.state,
    Key key,
  }) : super(key: key);
  final NoteState state;

  @override
  Widget build(BuildContext context) {
    //final isLoadingNewPage = context.select((DriveState s) => s.isLoadingFromBackend && s.pagination.currentPage != null);
    final isLoadingNewPage_ =
        context.select((NoteState s) => s.isLoadingFromBackend);
    //final lastBackendError = context.select((NoteState s) => s.lastBackendError);
    final entries = context.select((NoteState s) => s.entries);
    //final pagination = context.select((DriveState s) => s.pagination);
    return Center(child: Text("ddddd"));
    if (isLoadingNewPage_) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    /*else if (lastBackendError != null && !lastBackendError.noInternet) {
      return Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: 85,
          child: ErrorIndicator(
            compact: true,
            error: lastBackendError,
            onTryAgain: () => state.loadEntries(state.pagination.currentPage + 1),
          )
      );
    }*/
    /*else if(pagination.currentPage==pagination.lastPage){
      return Container();
    }*/
    else {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Center(child: CircularProgressIndicator()),
      );
      //return Container();
    }
  }
}
