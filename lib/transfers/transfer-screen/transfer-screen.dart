import 'package:flutter/material.dart';
import 'package:note/config/app-config.dart';
import 'package:note/note/screens/file-list/error-indecator/base-indecator.dart';
import 'package:note/note/state/root-navigator-key.dart';
import 'package:note/transfers/transfer-queue/file-transfer.dart';
import 'package:note/transfers/transfer-queue/transfer-queue.dart';
import 'package:note/transfers/transfer-screen/transfer-screen-list-tile.dart';
import 'package:note/utils/text.dart';
import 'package:provider/provider.dart';


class TransfersScreen extends StatelessWidget {
  static const ROUTE = 'transfers';

  static open() async {
    await rootNavigatorKey.currentState.pushNamed(TransfersScreen.ROUTE);
    //await rootNavigatorKey.currentState.pushNamed(TransfersScreen.ROUTE);
    //Navigator.of( rootNavigatorKey.currentContext).pushNamed(TransfersScreen.ROUTE);

    final queue = rootNavigatorKey.currentContext.read<TransferQueue>();
    if (queue != null) {
      queue.clearCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build transfer========================");
    return  Scaffold(
        appBar: AppBar(title: text('Transfers')),
        body: _TransfersList(),
    );
  }
}

class _TransfersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transfers = context.select((TransferQueue s) => s.queue);

    if (transfers.isEmpty) {
      return _NoTransfersMessage();
    }

    final downloads = transfers.values.where((e) => e.type == FileTransferType.download).toList();
    final uploads = transfers.values.where((e) => e.type == FileTransferType.upload).toList();
    final offline = transfers.values.where((e) => e.type == FileTransferType.offline).toList();
    print(downloads.length);
    List<Widget> children = [];

    if (downloads.isNotEmpty) {
      children.add(_TransferSection('downloads', downloads));
    }
    if (uploads.isNotEmpty) {
      children.add(_TransferSection('uploads', uploads));
    }
    if (offline.isNotEmpty) {
      children.add(_TransferSection('offline', offline));
    }

    return CustomScrollView(
      slivers: children,
    );
  }
}

class _TransferSection extends StatelessWidget {
  _TransferSection(this.title, this.transfers, {Key key}) : super(key: key);
  final String title;
  final List<FileTransfer> transfers;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(left: 20, top: 15),
            child: text(title, capitalize: true, size: 16, color: Theme.of(context).textTheme.caption.color),
          );
        }
        //index -= 1;
        index=transfers.length-index;
        return TransfersScreenListTile(transfers.elementAt(index));
      },  childCount: transfers.length + 1),
    );
  }
}


class _NoTransfersMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = context.select((AppConfig s) => s.appName);
    return Container(
      child: Center(
        child: BaseIndicator(
            title: 'No active file transfers',
            message: 'All active transfers between $appName and your device will appear here.',
            assetPath: 'assets/icons/transfer-files.svg'
        ),
      ),
    );
  }
}