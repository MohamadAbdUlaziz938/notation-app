import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:note/note/dialogs/cofirm-dialog.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:note/note/http/file-entry-api.dart';
import 'package:note/note/screens/file-list/base_file_list_screen.dart';
import 'package:note/note/state/entry_cach.dart';
import 'package:note/note/state/file_pages.dart';

import 'file-entry.dart';
import 'note.dart';
import 'root-navigator-key.dart';

class NoteState extends ChangeNotifier {
  final FileEntryApi api;
  final EntryCache entryCache;
  final scrollController = ScrollController();
  PageController pageController = PageController();
  Duration pageTurnDuration = Duration(milliseconds: 500);
  Curve pageTurnCurve = Curves.ease;
  int currentIndex = 0;

  String title;
  String note;
  String imageUrl;
  String userId;
  String documentId;
  int selectedPage;
  FilePage activePage;

  List<String> entries = [];
  Map<String, FileEntry> entriesFile = {};
  //Pagination pagination = Pagination();
  bool isLoadingFromBackend = false;
  bool isRefreshIndecator = false;
  bool deleteWhenFileOpened = false;

  get getTitle => this.title;
  get getNote => this.note;
  get getImageUrl => this.imageUrl;
  get getUserId => this.userId;
  get getDocumentId => this.documentId;

  NoteState({this.api, this.activePage, this.entryCache}) {
    _bindToScrollController();

    if (activePage == null) {
      activePage = RootFolderPage();
      selectedPage = 0;
    }
    // load initial entries
    if (activePage is! SearchPage) {
      loadEntries(1);
    }
  }

  dispose() {
    // transferQueueSub.cancel();
    // if (cancelToken != null && !cancelToken.isCancelled) {
    //   cancelToken.cancel();
    // }
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  openPage(FilePage page) {
    if (activePage.uniqueId != page.uniqueId) {
      //clearEntries();
      //scrollTo(0);
      activePage = page;
      // selectedEntries = [];
      loadEntries(1);
      notifyListeners();
    }
  }

  Future<void> reloadEntries() async {
    // deselectAll();
    clearEntries();
    scrollTo(0);
    await loadEntries(1);
    //isRefresh(true);
  }

  clearEntries() {
    // pagination = Pagination();
    entries = [];
    // entryCache.clear_entries();
    notifyListeners();
  }

  loadEntries(int page) async {
    isLoadingFromBackend = true;
    // if (cancelToken != null && cancelToken.isCancelled == false) {
    //   cancelToken.cancel();
    // }
    // cancelToken = CancelToken();

    final params = activePage.getQueryParams(page);
    QuerySnapshot querySnapshot;

    try {
      bool skipLoad = params.keys.contains('skipLoadFromBackend');
      // final liveResponse = skipLoad
      //     ? await Future.value(null)
      //     : await api.loadEntries(params,"");
      final liveResponse = await api.loadEntries(params, "");
      liveResponse.onData((data) {
        //querySnapshot=data;
        _handleRawLoadedEntriesResponse(page, data);
      });
      //cancelToken = null;

      if (liveResponse != null) {
        //entryCache.cacheResponse(liveResponse, params);
      }
    } catch (e) {
      // on offlined entries page load using local offlined entries db
      /*if (activePage is OfflinedPage) {
        final data = await offlinedEntriesDB.loadEntries(page, params: params);
        _handleLoadEntriesResponse(page, data);
      }*/
      // if there's no internet check cache
      // else if (e.noInternet) {
      //   final cachedResponse = await entryCache.getResponse(params);
      //   if (cachedResponse != null) {
      //     _handleRawLoadedEntriesResponse(page, cachedResponse);
      //   }
      // }
      /*
      // otherwise show error message
      else if (!e.isCancel) {
        //lastBackendError = e;
        isLoadingFromBackend = false;
       // cancelToken = null;
        notifyListeners();
      }*/
      notifyListeners();
    }
  }

  Future<void> deleteEntries(List<String> entryIds,
      {bool deleteForever = false}) async {
    final confirmed = await showConfirmationDialog(
        rootNavigatorKey.currentContext,
        title: 'Delete',
        subtitle: 'Are you sure you want to delete selected files?',
        confirmText: 'Delete',
        animationType: DialogTransitionType.slideFromBottomFade);
    if (confirmed != null && confirmed) {
      LoadingDialog.show(message: ('Deleting...'));
      try {
        await api.deleteFiles(entryIds, deleteForever: deleteForever);
        removeEntries(entryIds);
      } finally {
        LoadingDialog.hide();
        notifyListeners();
      }
    }
  }

  removeEntries(List<String> entryIds, {bool notify = false}) {
    final newEntriesList = [...entries];
    newEntriesList.removeWhere((id) => entryIds.contains(id));
    entries = newEntriesList;
    //pagination.total = max(pagination.total - entryIds.length, 0);
    if (notify) {
      notifyListeners();
    }
  }

  void _handleRawLoadedEntriesResponse(int page, QuerySnapshot response) {
    dynamic decoded;
    try {
      //decoded = json.decode(response.docs);
    } catch (e) {}
    //print(response[0]);
    print("======2=========");
    _handleLoadEntriesResponse(page, response);
  }

  void _handleLoadEntriesResponse(int page, QuerySnapshot response) {
    // pagination =
    // response == null ? Pagination.empty() : Pagination.fromJson(response);
    //Iterable data = response == null ? [] : response['data'];

    entries = List.from(entries);
    response.docs.map((e) {
      final fileEntry = FileEntry.fromJson(e.data());
      entryCache.set(fileEntry.documentId, fileEntry);

      entries.contains(fileEntry.documentId)
          ? null
          : entries.add(fileEntry.documentId);
    }).toList();
    entriesFile = entryCache.all;
    //lastBackendError = null;
    isLoadingFromBackend = false;
    notifyListeners();
  }

  scrollTo(double value) {
    if (scrollController != null && scrollController.hasClients) {
      scrollController.jumpTo(value);
    }
  }

  _bindToScrollController() {
    scrollController.addListener(() {
      var threshold = 0.9 * scrollController.position.maxScrollExtent;
      // if (scrollController.position.userScrollDirection ==
      //     ScrollDirection.reverse &&
      //     scrollController.position.pixels > threshold &&
      //     !isLoadingFromBackend &&
      //     lastBackendError == null &&
      //     pagination.currentPage < pagination.lastPage) {
      //   loadEntries(pagination.currentPage + 1);
      // }
    });
  }



  void CurrentIndexPageController(int page,{bool onTap=true}) {
    if (page != currentIndex) {
      currentIndex = page;
      print(currentIndex);
      onTap?animateToPage():null;
    }
    notifyListeners();
  }
  void animateToPage(){
    pageController.animateToPage(currentIndex,
        duration: pageTurnDuration, curve: pageTurnCurve);
  }


}
